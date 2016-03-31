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
        self.avatarObject?.setHair(FKAvatarHair(gender: gender)) { (success: Bool, error: NSError?) -> Void in
            
        }
    }
    
    @IBAction func changeSuit(sender: UIButton) {
        self.avatarObject?.setSuit(FKAvatarSuit(gender: gender, number: 3014)) { (success: Bool, error: NSError?) -> Void in
            
        }
    }
    
    @IBAction func changeMotion(sender: UIButton) {
        self.avatarObject?.setMotion(FKAvatarMotion(gender: gender)) { (success: Bool, error: NSError?) -> Void in
            
        }
    }
    
    @IBAction func changeGlasses(sender: UIButton) {
        self.avatarObject?.setGlasses(FKAvatarGlasses(gender: gender)) { (success: Bool, error: NSError?) -> Void in
            
        }
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
