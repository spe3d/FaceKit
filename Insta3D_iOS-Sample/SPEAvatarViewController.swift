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

class SPEAvatarViewController: SPEViewController {

    @IBOutlet var avatarView: SCNView?
    
    dynamic var avatar: FKAvatar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RACObserve(self, "avatar").ignoreNil().distinctUntilChanged().filter({ (avatar) -> Bool in
            if let avatar = avatar as? FKAvatar {
                return !avatar.defaultDownloaded
            }
            return false
        }).subscribeNext { (avatar) -> Void in
            if let avatar = avatar as? FKAvatar {

                RACObserve(self.avatar, "defaultDownloaded").subscribeNext({ (defaultDownloaded) -> Void in
                    if let defaultDownloaded = defaultDownloaded as? Bool {
                        if defaultDownloaded {
                            MBProgressHUD.hideAllHUDsForView(self.view.window, animated: true)
                            
                            self.createCustomHead()
                        }
                    }
                })
                FKHTTPRequestOperationManager.currentManager().getAvatar(avatar.avatarID, success: { (operation, responseObject) -> Void in
                    if let responseObject = responseObject as? [String:AnyObject] {
                        if let data = responseObject["data"] as? [String: String] {
                            self.setupAvatar(data)
                        }
                    }
                    }, failure: { (operation, error) -> Void in
                        
                })
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAvatar(data: [String:String]) {
        for (skinColorName, skinColorURL) in data {
            if let url = NSURL(string: skinColorURL) {
                if let headSkinColor = FKHeadSkinColor(rawValue: skinColorName) {
                    self.getAvatarHeadImage(headSkinColor, url: url)
                }
                else if let bodySkinColor = FKBodySkinColor(rawValue: skinColorName) {
                    self.getAvatarBodyImage(bodySkinColor, url: url)
                }
                else if skinColorName == "RefInfo" {
                    self.getAvatarRefInfo(url)
                }
            }
        }
    }
    
    func getAvatarHeadImage(skinColor: FKHeadSkinColor, url: NSURL) {
        let request = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30)
        let requestOperation = AFHTTPRequestOperation(request: request)
        requestOperation.responseSerializer = AFImageResponseSerializer()
        requestOperation.setCompletionBlockWithSuccess({ (operation, responseObject) -> Void in
            if let responseObject = responseObject as? UIImage {
                self.avatar?.headImages[skinColor] = responseObject
            }
            }, failure: { (operation, error) -> Void in
                
        })
        requestOperation.start()
    }
    
    func getAvatarBodyImage(skinColor: FKBodySkinColor, url: NSURL) {
        let request = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30)
        let requestOperation = AFHTTPRequestOperation(request: request)
        requestOperation.responseSerializer = AFImageResponseSerializer()
        requestOperation.setCompletionBlockWithSuccess({ (operation, responseObject) -> Void in
            if let responseObject = responseObject as? UIImage {
                self.avatar?.bodyImages[skinColor] = responseObject
            }
            }, failure: { (operation, error) -> Void in
                
        })
        requestOperation.start()
    }
    
    func getAvatarRefInfo(url: NSURL) {
        let request = NSURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30)
        let requestOperation = AFHTTPRequestOperation(request: request)
        requestOperation.responseSerializer = AFHTTPResponseSerializer()
        requestOperation.setCompletionBlockWithSuccess({ (operation, responseObject) -> Void in
            if let responseObject = responseObject as? NSData {
                self.avatar?.refInfo = String(NSString(data: responseObject, encoding: NSUTF8StringEncoding))
            }
            }, failure: { (operation, error) -> Void in
                
        })
        requestOperation.start()
    }
    
    func createCustomHead() {
        if let scene = self.avatarView?.scene {
            if let defaultHead = scene.rootNode.childNodeWithName("A_Q3_M_Hd", recursively: true) {

                if let avatar = self.avatar {
                    defaultHead.geometry?.firstMaterial?.diffuse.contents = avatar.headImages[.Default]
                    scene.rootNode.childNodeWithName("A_Q3_M_Bd", recursively: true)?.geometry?.firstMaterial?.diffuse.contents = avatar.bodyImages[.Default]
                    
                    var targets: [SCNGeometry] = []
                    for i in 0..<avatar.geometrySourcesSemanticNormal.count {
                        var geometrySources: [SCNGeometrySource] = []
                        if let geometry = defaultHead.geometry {
                            for geometrySource in geometry.geometrySources {
                                switch geometrySource.semantic {
                                case SCNGeometrySourceSemanticTexcoord:
                                    geometrySources.append(geometrySource)
                                    break
                                case SCNGeometrySourceSemanticNormal:
                                    geometrySources.append(avatar.geometrySourcesSemanticNormal[i])
                                    break
                                case SCNGeometrySourceSemanticVertex:
                                    geometrySources.append(avatar.geometrySourcesSemanticVertex[i])
                                    break
                                default:
                                    break
                                }
                            }
                            
                            targets.append(SCNGeometry(sources: geometrySources, elements: geometry.geometryElements))
                        }
                    }
                    
                    if defaultHead.morpher == nil {
                        defaultHead.morpher = SCNMorpher()
                    }
                    defaultHead.morpher?.targets = targets
                    
                    defaultHead.morpher?.setWeight(1, forTargetAtIndex: 0)
                }
                
//                let animation = CABasicAnimation(keyPath: "morpher.weights[0]")
//                animation.fromValue = 0.0
//                animation.toValue = 1.0
//                animation.autoreverses = true
//                animation.repeatCount = MAXFLOAT
//                animation.duration = 1
//                defaultHead.addAnimation(animation, forKey: nil)
            }
        }
    }
    
    func addMotion(animationName: String?) {
        if let avatarNode = self.avatarView?.scene?.rootNode.childNodeWithName("Hips", recursively: true) {
            avatarNode.removeAllAnimations()
            
            if animationName?.isEmpty == false {
                let animationName = animationName!
                let node = SCNScene(named: "avatar.scnassets/\(animationName).dae")!.rootNode.childNodeWithName("Hips", recursively: true)!
                for animationKey in node.animationKeys {
                    let animation = node.animationForKey(animationKey)!
                    animation.usesSceneTimeBase = false
                    animation.repeatCount = MAXFLOAT
                    avatarNode.addAnimation(animation, forKey: animationKey)
                }
            }
        }
    }
    
    func addHair(hairName: String?) {
        if let head = self.avatarView?.scene?.rootNode.childNodeWithName("Head", recursively: true) {
            for hair in head.childNodes {
                if hair.name?.rangeOfString("_Hr_") != nil {
                    hair.removeFromParentNode()
                }
            }
            
            if hairName?.isEmpty == false {
                let hairName = hairName!
                if let node = SCNScene(named: "avatar.scnassets/\(hairName)/\(hairName).dae")?.rootNode.childNodeWithName(hairName, recursively: true) {
                    head.addChildNode(node)
                }
            }
        }
    }
    
    func addClothes(clothesName: String?) {
        if let rootNode = self.avatarView?.scene?.rootNode {
            if let defaultBody = rootNode.childNodeWithName("A_Q3_M_Bd", recursively: false) {
                defaultBody.hidden = false
                
                if clothesName?.isEmpty == false {
                    let clothesName = clothesName!
                    
                    if let node = SCNScene(named: "avatar.scnassets/\(clothesName)/\(clothesName).dae")?.rootNode {
                        defaultBody.hidden = true
                        
                        for body in rootNode.childNodes {
                            if body.name?.rangeOfString("_S_") != nil {
                                body.removeFromParentNode()
                            }
                        }
                        
                        for body in node.childNodes {
                            if let geometry = body.geometry {
                                
                                geometry.convertContentsPathToImage()
                                
                                rootNode.addChildNode(body)
                                body.skinner?.skeleton = defaultBody.skinner?.skeleton
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - action
    
    @IBAction func uploadFaceAction(sender: UIButton) {
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("SPECameraViewController") as? SPECameraViewController {
            controller.modalTransitionStyle = .CrossDissolve
            self.presentViewController(controller, animated: true, completion: nil)
            
            RACObserve(controller, "avatar").ignoreNil().subscribeNext { (avatar) -> Void in
                if let avatar = avatar as? FKAvatar {
                    self.avatar = avatar
                    controller.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func changeHair(sender: UIButton) {
        if let avatar = self.avatar {
            if avatar.hair == nil {
                avatar.hair = FKAvatarHair(gender: avatar.gender)
            }
            else {
                avatar.hair = nil
            }
            addHair(avatar.hair?.name())
        }
    }
    
    @IBAction func changeClothes(sender: UIButton) {
        if let avatar = self.avatar {
            while (true) {
                let clothes = FKAvatarClothes(gender: avatar.gender)
                
                if avatar.clothes?.name() != clothes.name() {
                    avatar.clothes = clothes
                    
                    break
                }
            }
            addClothes(avatar.clothes?.name())
        }
    }
    
    @IBAction func changeMotion(sender: UIButton) {
        if let avatar = self.avatar {
            if avatar.motion == nil {
                avatar.motion = FKAvatarMotion(gender: avatar.gender)
            }
            else {
                avatar.motion = nil
            }
            addMotion(avatar.motion?.name())
        }
    }

}
