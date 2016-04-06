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
    
    @IBOutlet var cleanButton: UIButton?
    
    var avatarObject: FKAvatarObject?
    var gender = FKGender.Male
    
    var avatarData: NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func assignAvatarObject(avatarObject: FKAvatarObject) {
        let scene = SCNScene()
        self.avatarView.scene = scene
        self.avatarHeadView.scene = scene
        
        self.avatarObject = avatarObject
        
        self.avatarView.scene?.rootNode.addChildNode(self.avatarObject!.sceneNode)
        self.avatarView.pointOfView = self.avatarObject!.defaultCameraNode
        self.avatarHeadView.pointOfView = self.avatarObject!.headCameraNode
    }
    
    // MARK: - action
    
    @IBAction func getDefaultAvatarAction(sender: UIButton) {
        guard let avatarObject = FKAvatarObject(genderOfDefaultAvatar: self.gender) else {
            return
        }
        
        self.assignAvatarObject(avatarObject)
    }
    
    @IBAction func saveAvatarAction(sender: UIButton) {
        guard let avatarObject = self.avatarObject else {
            return
        }
        self.avatarData = NSKeyedArchiver.archivedDataWithRootObject(avatarObject)
    }
    
    @IBAction func loadAvatarAction(sender: UIButton) {
        guard let avatarData = self.avatarData else {
            return
        }
        
        guard let avatarObject = NSKeyedUnarchiver.unarchiveObjectWithData(avatarData) as? FKAvatarObject else {
            return
        }
        
        self.assignAvatarObject(avatarObject)
    }
    
    @IBAction func cleanAvatarAction(sender: UIButton) {
        guard let rootNode = self.avatarView.scene?.rootNode else {
            return
        }
        
        for node in rootNode.childNodes {
            node.removeFromParentNode()
        }
        
        self.avatarObject = nil
        self.avatarView.scene = nil
        self.avatarHeadView.scene = nil
    }
    
    @IBAction func switchGenderAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.gender = .Male
        case 1:
            self.gender = .Female
        default: break
        }
        
        self.cleanButton?.sendActionsForControlEvents(.TouchUpInside)
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
        controller.avatarPresetType = FKHair.self
        controller.selectPresetClosure = {(preset: FKAvatarPreset) -> Void in
            if let hair = preset as? FKHair {
                let hud = MBProgressHUD(view: self.view)
                hud.labelText = "Downloading..."
                
                self.view.addSubview(hud)
                hud.show(true)
                self.avatarObject?.setHair(hair, completionHandler: { (success: Bool, error: NSError?) in
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    
                    if let error = error {
                        NSLog("%@", error)
                    }
                    
                    NSLog("\(success)")
                })
            }
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
        controller.avatarPresetType = FKSuit.self
        controller.selectPresetClosure = {(preset: FKAvatarPreset) -> Void in
            if let suit = preset as? FKSuit {
                let hud = MBProgressHUD(view: self.view)
                hud.labelText = "Downloading..."
                
                self.view.addSubview(hud)
                hud.show(true)
                self.avatarObject?.setSuit(suit, completionHandler: { (success: Bool, error: NSError?) in
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    
                    if let error = error {
                        NSLog("%@", error)
                    }
                    
                    NSLog("\(success)")
                })
            }
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
            if let motion = preset as? FKAvatarMotion {
                let hud = MBProgressHUD(view: self.view)
                hud.labelText = "Downloading..."
                
                self.view.addSubview(hud)
                hud.show(true)
                self.avatarObject?.setMotion(motion, completionHandler: { (success: Bool, error: NSError?) in
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    
                    if let error = error {
                        NSLog("%@", error)
                    }
                    
                    NSLog("\(success)")
                })
            }
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
        controller.avatarPresetType = FKGlasses.self
        controller.selectPresetClosure = {(preset: FKAvatarPreset) -> Void in
            if let glasses = preset as? FKGlasses {
                let hud = MBProgressHUD(view: self.view)
                hud.labelText = "Downloading..."
                
                self.view.addSubview(hud)
                hud.show(true)
                self.avatarObject?.setGlasses(glasses, completionHandler: { (success: Bool, error: NSError?) in
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    
                    if let error = error {
                        NSLog("%@", error)
                    }
                    
                    NSLog("\(success)")
                })
            }
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
