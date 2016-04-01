//
//  SPEAvatarViewController.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/15.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit
import SceneKit
import MBProgressHUD
import FaceKit

class SPEAvatarViewController: SPEViewController, SPECameraViewControllerDelegate {

    @IBOutlet var avatarView: SCNView!
    @IBOutlet var avatarHeadView: SCNView!
    
    var avatarObject: FKAvatarObject?
    var gender = FKGender.Male
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = SCNScene()
        self.avatarView.scene = scene
        self.avatarHeadView.scene = scene
        
        guard let object = FKAvatarObject(genderOfDefaultAvatar: gender) else {
            return
        }
        let avatarData = NSKeyedArchiver.archivedDataWithRootObject(object)
        guard let newObject = NSKeyedUnarchiver.unarchiveObjectWithData(avatarData) else {
            return
        }
        
        guard let avatarObject = newObject as? FKAvatarObject else {
            return
        }
        
        self.avatarObject = avatarObject
        
        self.avatarView.scene?.rootNode.addChildNode(self.avatarObject!.sceneNode)
        self.avatarView.pointOfView = self.avatarObject!.defaultCameraNode
        self.avatarHeadView.pointOfView = self.avatarObject!.headCameraNode
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - action
    
    @IBAction func switchGenderAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.gender = .Male
        case 1:
            self.gender = .Female
        default: break
        }
    }
    
    @IBAction func uploadFaceAction(sender: UIButton) {
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("SPECameraViewController") as? SPECameraViewController {
            controller.modalTransitionStyle = .CrossDissolve
            controller.gender = self.gender
            controller.delegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeHair(sender: UIButton) {
        guard let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("SPEAvatarPresetNavigationController") as? UINavigationController else {
            return
        }
        guard let controller = navigationController.viewControllers[0] as? SPEAvatarPresetTableViewController else {
            return
        }
        controller.gender = self.gender
        controller.avatarPresetType = FKAvatarHair.self
        controller.selectPresetClosure = {(preset: FKAvatarPreset) -> Void in
            
        }
        controller.title = "Hair"
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func changeSuit(sender: UIButton) {
        guard let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("SPEAvatarPresetNavigationController") as? UINavigationController else {
            return
        }
        guard let controller = navigationController.viewControllers[0] as? SPEAvatarPresetTableViewController else {
            return
        }
        controller.gender = self.gender
        controller.avatarPresetType = FKAvatarSuit.self
        controller.selectPresetClosure = {(preset: FKAvatarPreset) -> Void in
            
        }
        controller.title = "Suit"
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func changeMotion(sender: UIButton) {
        guard let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("SPEAvatarPresetNavigationController") as? UINavigationController else {
            return
        }
        guard let controller = navigationController.viewControllers[0] as? SPEAvatarPresetTableViewController else {
            return
        }
        controller.gender = self.gender
        controller.avatarPresetType = FKAvatarMotion.self
        controller.selectPresetClosure = {(preset: FKAvatarPreset) -> Void in
            
        }
        controller.title = "Motion"
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func changeGlasses(sender: UIButton) {
        guard let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("SPEAvatarPresetNavigationController") as? UINavigationController else {
            return
        }
        guard let controller = navigationController.viewControllers[0] as? SPEAvatarPresetTableViewController else {
            return
        }
        controller.gender = self.gender
        controller.avatarPresetType = FKAvatarGlasses.self
        controller.selectPresetClosure = {(preset: FKAvatarPreset) -> Void in
            
        }
        controller.title = "Glasses"
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func talkAction(sender: UIButton) {
        var wavFileURL: NSURL? = nil
        switch sender.tag {
        case 1:
            wavFileURL = NSBundle.mainBundle().URLForResource("hello", withExtension: "wav")
            break
        case 2:
            wavFileURL = NSBundle.mainBundle().URLForResource("KP_NewYear_clip", withExtension: "wav")
            break
        case 3:
            wavFileURL = NSBundle.mainBundle().URLForResource("welcome_to_talkii", withExtension: "wav")
            break
        default:
            break
        }
        
        if let wavFileURL = wavFileURL {
            guard let wavFileData = NSData(contentsOfURL: wavFileURL) else {
                return
            }
            let hud = MBProgressHUD(view: self.view)
            hud.labelText = "Calculating..."
            
            self.view.addSubview(hud)
            hud.show(true)
            
            self.avatarObject?.saveAndPlayVoice(wavFileData, willPlayClosure: { () -> Void in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                }, completion: { (success: Bool) -> Void in
                    
            })
        }
    }
    
    @IBAction func replayTalkAction(sender: UIButton) {
        self.avatarObject?.playLastVoice({ (success: Bool) -> Void in
            NSLog("\(String(success))")
        })
    }

    // MARK: - SPECameraViewControllerDelegate
    
    func cameraViewController(viewController: SPECameraViewController, didCreateAvatarObject avatarObject: FKAvatarObject) {
        self.avatarObject = avatarObject
        
        if let rootNode = self.avatarView.scene?.rootNode {
            rootNode.childNodeWithName("FKAvatarNode", recursively: true)?.removeFromParentNode()
            rootNode.addChildNode(avatarObject.sceneNode)
            
            for node in rootNode.childNodes {
                if node.camera != nil {
                    node.removeFromParentNode()
                }
            }
        }
        
        self.avatarView.pointOfView = avatarObject.defaultCameraNode
        self.avatarHeadView.pointOfView = avatarObject.headCameraNode
    }
}
