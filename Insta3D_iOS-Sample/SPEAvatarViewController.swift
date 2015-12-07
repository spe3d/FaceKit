//
//  SPEAvatarViewController.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/15.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit
import SceneKit
import AFNetworking
import MBProgressHUD
import FaceKit

class SPEAvatarViewController: SPEViewController, SPECameraViewControllerDelegate {

    @IBOutlet var avatarView: SCNView!
    
    var avatarObject: FKAvatarObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.avatarView.scene = SCNScene(named: "Scene.dae")
        self.avatarView.scene = SCNScene(named: "Scene.scn")
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
        self.avatarObject?.setHair(FKAvatarHair(gender: .Male))
    }
    
    @IBAction func changeClothes(sender: UIButton) {
        self.avatarObject?.setClothes(FKAvatarClothes(gender: .Male))
    }
    
    @IBAction func changeMotion(sender: UIButton) {
        self.avatarObject?.setMotion(FKAvatarMotion(gender: .Male))
    }
    
    @IBAction func changeGlasses(sender: UIButton) {
        self.avatarObject?.setGlasses(FKAvatarGlasses(gender: .Male))
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

    // MARK: - SPECameraViewControllerDelegate
    
    func cameraViewController(viewController: SPECameraViewController, didCreateAvatarObject avatarObject: FKAvatarObject) {
        self.avatarObject = avatarObject
        
        self.avatarView.scene?.rootNode.childNodeWithName("FKAvatarNode", recursively: true)?.removeFromParentNode()
        self.avatarView.scene?.rootNode.addChildNode(avatarObject.sceneNode)
    }
}
