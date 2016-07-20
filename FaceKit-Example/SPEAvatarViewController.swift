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
    
    var avatarController: FKAvatarController?
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
    
    func assignAvatarController(avatarController: FKAvatarController) {
        let scene = SCNScene()
        self.avatarView.scene = scene
        self.avatarHeadView.scene = scene
        
        self.avatarController = avatarController
        
        self.avatarView.scene?.rootNode.addChildNode(avatarController.sceneNode)
        
        self.setupDefaultCamera()
        self.setupHeadCamera()
    }
    
    func setupDefaultCamera() {
        guard let camera = self.avatarController?.getDefaultCameraNode() else {
            return
        }
        
        self.avatarView.pointOfView = camera
    }
    
    func setupHeadCamera() {
        guard let camera = self.avatarView.scene?.rootNode.childNodeWithName("FKHeadCamera", recursively: true) else {
            return
        }
        
        self.avatarHeadView.pointOfView = camera
    }
    
    // MARK: - action
    
    @IBAction func showBackgroundAction(sender: UIButton) {
        self.avatarView.scene?.rootNode.childNodeWithName("background", recursively: true)?.removeFromParentNode()
        
        guard let avatarController = self.avatarController else {
            return
        }
        
        let scale = UIScreen.mainScreen().nativeScale / CGFloat(avatarController.sceneNode.childNodeWithName("Hips", recursively: true)!.scale.x)
        let image = UIImage(named: "mvp_bg")!
        let scenery = SCNPlane(width: image.size.width / scale, height: image.size.height / scale)
        scenery.firstMaterial?.diffuse.contents = image
        let node = SCNNode(geometry: scenery)
        node.name = "background"
        node.position = SCNVector3Make(0, 130, -130)
        self.avatarView.scene?.rootNode.addChildNode(node)
    }
    
    @IBAction func getDefaultAvatarAction(sender: UIButton) {
        guard let avatarController = FKAvatarController(genderOfDefaultAvatar: self.gender) else {
            return
        }
        
        self.assignAvatarController(avatarController)
    }
    
    @IBAction func saveAvatarAction(sender: UIButton) {
        guard let avatarController = self.avatarController else {
            return
        }
        self.avatarData = NSKeyedArchiver.archivedDataWithRootObject(avatarController)
    }
    
    @IBAction func loadAvatarAction(sender: UIButton) {
        guard let avatarData = self.avatarData else {
            return
        }
        
        guard let avatarController = NSKeyedUnarchiver.unarchiveObjectWithData(avatarData) as? FKAvatarController else {
            return
        }
        
        if avatarController.isWornPresets {
            self.assignAvatarController(avatarController)
        }
        else {
            avatarController.observeAvatarHasWornPresets({ (avatarSceneNode) in
                self.assignAvatarController(avatarController)
            })
        }
    }
    
    @IBAction func cleanAvatarAction(sender: UIButton) {
        guard let rootNode = self.avatarView.scene?.rootNode else {
            return
        }
        
        for node in rootNode.childNodes {
            node.removeFromParentNode()
        }
        
        self.avatarController = nil
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
        guard let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("SPEPresetNavigationController") as? UINavigationController else {
            return
        }
        guard let controller = navigationController.viewControllers[0] as? SPEPresetTableViewController else {
            return
        }
        controller.gender = self.gender
        controller.presetType = .Hair
        controller.selectPresetClosure = {(preset) -> Void in
            let hud = MBProgressHUD(view: self.view)
            hud.labelText = "Downloading..."
            
            self.view.addSubview(hud)
            hud.show(true)
            self.avatarController?.setPreset(preset, completionHandler: { (success: Bool, error: NSError?) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                if let error = error {
                    NSLog("%@", error)
                }
                
                NSLog("\(success)")
            })
        }
        controller.title = "Hair"
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func changeSuit(sender: UIButton) {
        guard let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("SPEPresetNavigationController") as? UINavigationController else {
            return
        }
        guard let controller = navigationController.viewControllers[0] as? SPEPresetTableViewController else {
            return
        }
        controller.gender = self.gender
        controller.presetType = .Suit
        controller.selectPresetClosure = {(preset) -> Void in
            let hud = MBProgressHUD(view: self.view)
            hud.labelText = "Downloading..."
            
            self.view.addSubview(hud)
            hud.show(true)
            self.avatarController?.setPreset(preset, completionHandler: { (success: Bool, error: NSError?) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                if let error = error {
                    NSLog("%@", error)
                }
                
                NSLog("\(success)")
            })
        }
        controller.title = "Suit"
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func changeMotion(sender: UIButton) {
        guard let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("SPEPresetNavigationController") as? UINavigationController else {
            return
        }
        guard let controller = navigationController.viewControllers[0] as? SPEPresetTableViewController else {
            return
        }
        controller.gender = self.gender
        controller.presetType = .Motion
        controller.selectPresetClosure = {(preset) -> Void in
            let hud = MBProgressHUD(view: self.view)
            hud.labelText = "Downloading..."
            
            self.view.addSubview(hud)
            hud.show(true)
            self.avatarController?.setPreset(preset, completionHandler: { (success: Bool, error: NSError?) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                if let error = error {
                    NSLog("%@", error)
                }
                
                NSLog("\(success)")
            })
        }
        controller.title = "Motion"
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func changeAccessory(sender: UIButton) {
        guard let navigationController = self.storyboard?.instantiateViewControllerWithIdentifier("SPEPresetNavigationController") as? UINavigationController else {
            return
        }
        guard let controller = navigationController.viewControllers[0] as? SPEPresetTableViewController else {
            return
        }
        controller.gender = self.gender
        controller.presetType = .Accessory
        controller.selectPresetClosure = {(preset) -> Void in
            let hud = MBProgressHUD(view: self.view)
            hud.labelText = "Downloading..."
            
            self.view.addSubview(hud)
            hud.show(true)
            self.avatarController?.setPreset(preset, completionHandler: { (success: Bool, error: NSError?) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                if let error = error {
                    NSLog("%@", error)
                }
                
                NSLog("\(success)")
            })
        }
        controller.title = "Accessory"
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
            
            self.avatarController?.saveAndPlayVoice(wavFileData, willPlayClosure: { () -> Void in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                }, completion: { (success: Bool) -> Void in
                    
            })
        }
    }
    
    @IBAction func replayTalkAction(sender: UIButton) {
        self.avatarController?.playLastVoice({ (success: Bool) -> Void in
            NSLog("\(String(success))")
        })
    }

    // MARK: - SPECameraViewControllerDelegate
    
    func cameraViewController(viewController: SPECameraViewController, didCreateAvatarController avatarController: FKAvatarController) {
        self.avatarController = avatarController
        
        if let rootNode = self.avatarView.scene?.rootNode {
            rootNode.childNodeWithName("FKAvatarNode", recursively: true)?.removeFromParentNode()
            rootNode.addChildNode(avatarController.sceneNode)
            
            for node in rootNode.childNodes {
                if node.camera != nil {
                    node.removeFromParentNode()
                }
            }
        }
    }
}
