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
    var gender = FKGender.Female
    
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
    
    @IBAction func uploadFaceAction(sender: UIButton) {
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("SPECameraViewController") as? SPECameraViewController {
            controller.modalTransitionStyle = .CrossDissolve
            controller.delegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeHair(sender: UIButton) {
        self.avatarObject?.setHair(FKAvatarHair(gender: gender)) { (success: Bool, error: NSError?) -> Void in
            
        }
    }
    
    @IBAction func changeClothes(sender: UIButton) {
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
    
    var index = 0
    @IBAction func changeFacial(sender: UIButton) {
        var weights = [Float].init(count: 14, repeatedValue: 0)
        weights[index++ % 14] = 1
        self.avatarObject?.setFacial(weights)
    }
    
    @IBAction func changeSkinColor(sender: UIButton) {
        if sender.tag == 0 {
            self.avatarObject?.setSkinColor(.Black)
            sender.tag = 1
        }
        else {
            self.avatarObject?.setSkinColor(.Default)
            sender.tag = 0
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
