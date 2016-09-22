//
//  SPEAvatarViewController.swift
//  FaceKit
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
    
    @IBOutlet var versionSegmented: UISegmentedControl!

    @IBOutlet var cleanButton: UIButton?

    @IBOutlet var headViewSizeConstraint: NSLayoutConstraint?

    var avatarController: FACAvatarController?

    var gender = FACGender.male

    var avatarData: Data?


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func assignAvatarController(_ avatarController: FACAvatarController) {
        let scene = SCNScene()
        self.avatarView.scene = scene
        self.avatarHeadView.scene = scene

        self.avatarController = avatarController

        self.avatarView.scene?.rootNode.addChildNode(avatarController.sceneNode)

        self.setupDefaultCamera()
        self.setupHeadCamera()
    }

    func setupDefaultCamera() {
        let camera = FACAvatarController.getDefaultCameraNode()

        self.avatarView.scene?.rootNode.addChildNode(camera)

        self.avatarView.pointOfView = camera
    }

    func setupHeadCamera() {
        guard let camera = self.avatarController?.getHeadCameraNode() else {
            return
        }

        self.avatarView.scene?.rootNode.childNode(withName: "Neck", recursively: true)?.addChildNode(camera)

        self.avatarHeadView.pointOfView = camera
    }

    // MARK: - action

    @IBAction func zoomHeadSceneViewAction(_ sender: UIButton) {
        guard let constraint = self.headViewSizeConstraint else {
            return
        }

        if constraint.constant < 100 {
            constraint.constant = 120
        }
        else {
            constraint.constant = 50
        }
    }

    @IBAction func facialAction(_ sender: UIButton) {
        self.avatarController?.setFacialWithWeights([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1])
    }
    
    @IBAction func showBackgroundAction(_ sender: UIButton) {
        self.avatarView.scene?.rootNode.childNode(withName: "background", recursively: true)?.removeFromParentNode()

        guard let avatarController = self.avatarController else {
            return
        }

        let scale = UIScreen.main.nativeScale / CGFloat(avatarController.sceneNode.childNode(withName: "Hips", recursively: true)!.scale.x)
        let image = UIImage(named: "mvp_bg")!
        let scenery = SCNPlane(width: image.size.width / scale, height: image.size.height / scale)
        scenery.firstMaterial?.diffuse.contents = image
        let node = SCNNode(geometry: scenery)
        node.name = "background"
        node.position = SCNVector3Make(0, 130, -130)
        self.avatarView.scene?.rootNode.addChildNode(node)
    }

    @IBAction func getDefaultAvatarAction(_ sender: UIButton) {
        let avatarController = FACAvatarController(genderOfDefaultAvatar: self.gender, version: Int(self.versionSegmented.titleForSegment(at: self.versionSegmented.selectedSegmentIndex)!)!)

        self.assignAvatarController(avatarController)
    }

    @IBAction func saveAvatarAction(_ sender: UIButton) {
        guard let avatarController = self.avatarController else {
            return
        }
        self.avatarData = NSKeyedArchiver.archivedData(withRootObject: avatarController)
    }

    @IBAction func loadAvatarAction(_ sender: UIButton) {
        guard let avatarData = self.avatarData else {
            return
        }

        guard let avatarController = NSKeyedUnarchiver.unarchiveObject(with: avatarData) as? FACAvatarController else {
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

    @IBAction func cleanAvatarAction(_ sender: UIButton) {
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

    @IBAction func switchGenderAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.gender = .male
        case 1:
            self.gender = .female
        default: break
        }

        self.cleanButton?.sendActions(for: .touchUpInside)
    }

    @IBAction func uploadFaceAction(_ sender: UIButton) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "SPECameraViewController") as? SPECameraViewController {
            controller.modalTransitionStyle = .crossDissolve
            controller.gender = self.gender
            controller.version = Int(self.versionSegmented.titleForSegment(at: self.versionSegmented.selectedSegmentIndex)!)!
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }

    @IBAction func changeHair(_ sender: UIButton) {
        guard let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "SPEPresetNavigationController") as? UINavigationController else {
            return
        }
        guard let controller = navigationController.viewControllers[0] as? SPEPresetTableViewController else {
            return
        }
        controller.gender = self.gender
        controller.presetType = .hair
        controller.selectPresetClosure = {(preset) -> Void in
            let hud = MBProgressHUD(view: self.view)
            hud?.labelText = "Downloading..."

            self.view.addSubview(hud!)
            hud?.show(true)
            self.avatarController?.setHair(preset, completionHandler: { (success: Bool, error: Error?) in
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

                if let error = error as? NSError {
                    NSLog("%@", error)
                }

                NSLog("\(success)")
            })
        }
        controller.title = "Hair"
        self.present(navigationController, animated: true, completion: nil)
    }

    @IBAction func changeSuit(_ sender: UIButton) {
        guard let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "SPEPresetNavigationController") as? UINavigationController else {
            return
        }
        guard let controller = navigationController.viewControllers[0] as? SPEPresetTableViewController else {
            return
        }
        controller.gender = self.gender
        controller.presetType = .suit
        controller.selectPresetClosure = {(preset) -> Void in
            let hud = MBProgressHUD(view: self.view)
            hud?.labelText = "Downloading..."

            self.view.addSubview(hud!)
            hud?.show(true)
            self.avatarController?.setSuit(preset, completionHandler: { (success: Bool, error: Error?) in
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

                if let error = error as? NSError {
                    NSLog("%@", error)
                }

                NSLog("\(success)")
            })
        }
        controller.title = "Suit"
        self.present(navigationController, animated: true, completion: nil)
    }

    @IBAction func changeMotion(_ sender: UIButton) {
        guard let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "SPEPresetNavigationController") as? UINavigationController else {
            return
        }
        guard let controller = navigationController.viewControllers[0] as? SPEPresetTableViewController else {
            return
        }
        controller.gender = self.gender
        controller.presetType = .motion
        controller.selectPresetClosure = {(preset) -> Void in
            let hud = MBProgressHUD(view: self.view)
            hud?.labelText = "Downloading..."

            self.view.addSubview(hud!)
            hud?.show(true)
            self.avatarController?.setMotion(preset, completionHandler: { (success: Bool, error: Error?) in
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

                if let error = error as? NSError {
                    NSLog("%@", error)
                }

                NSLog("\(success)")
            })
        }
        controller.title = "Motion"
        self.present(navigationController, animated: true, completion: nil)
    }

    @IBAction func changeAccessory(_ sender: UIButton) {
        guard let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "SPEPresetNavigationController") as? UINavigationController else {
            return
        }
        guard let controller = navigationController.viewControllers[0] as? SPEPresetTableViewController else {
            return
        }
        controller.gender = self.gender
        controller.presetType = .accessory
        controller.selectPresetClosure = {(preset) -> Void in
            let hud = MBProgressHUD(view: self.view)
            hud?.labelText = "Downloading..."

            self.view.addSubview(hud!)
            hud?.show(true)
            self.avatarController?.setAccessory(preset, completionHandler: { (success: Bool, error: Error?) in
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

                if let error = error as? NSError {
                    NSLog("%@", error)
                }

                NSLog("\(success)")
            })
        }
        controller.title = "Accessory"
        self.present(navigationController, animated: true, completion: nil)
    }

    // MARK: - SPECameraViewControllerDelegate

    func cameraViewController(_ viewController: SPECameraViewController, didCreateAvatarController avatarController: FACAvatarController) {
        self.assignAvatarController(avatarController)
    }
}
