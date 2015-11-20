//
//  SPEAvatarViewController.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/15.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit
import SceneKit
import ReactiveCocoa
import Swift_RAC_Macros
import AFNetworking
import MBProgressHUD
import FaceKit

class SPEAvatarViewController: SPEViewController, SPECameraViewControllerDelegate {

    @IBOutlet var avatarView: SCNView!
    
    var avatarNode: FKAvatarSceneNode?
    
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
        self.avatarNode?.setHair(FKAvatarHair(gender: .Male))
    }
    
    @IBAction func changeClothes(sender: UIButton) {
        self.avatarNode?.setClothes(FKAvatarClothes(gender: .Male))
    }
    
    @IBAction func changeMotion(sender: UIButton) {
        self.avatarNode?.setMotion(FKAvatarMotion(gender: .Male))
    }

    // MARK: - SPECameraViewControllerDelegate
    
    func cameraViewController(viewController: SPECameraViewController, didCreateAvatarNode avatarNode: FKAvatarSceneNode) {
        self.avatarNode = avatarNode
        
        self.avatarView.scene?.rootNode.childNodeWithName("FKAvatarNode", recursively: true)?.removeFromParentNode()
        self.avatarView.scene?.rootNode.addChildNode(avatarNode)
    }
}
