//
//  FKAvatarObject.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/11/9.
//  Modified by Daniel on 2015/12/21.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit
import SceneKit

/**
 An `FKAvatarObject` object has a node of the avatar on a scene graph.
 You have to show the avatar, you need to add `sceneNode` in your scene.
 To modify style on the avatar, use methods of `FKAvatarObject` can immediately to update on the `sceneNode`.
 */
public class FKAvatarObject: NSObject {
    let kDefaultSceneNodeName = "FKAvatarNode"
    
    let avatar: FKAvatar?
    
    /**
     The node of the avatar on the scene graph.
     */
    public let sceneNode = SCNNode()
    
    /**
     The default camera shoots the avatar with full body.
     */
    public let defaultCameraNode = SCNNode()
    
    /**
     Get focused on the avatar's head of the camera.
     */
    public let headCameraNode = SCNNode()
    
    /**
     Create a default avatar.
    */
    public init(genderOfDefaultAvatar gender: FKGender) {
        self.avatar = FKAvatar(gender: gender)
        super.init()
        let scene = FKAvatarManager.defaultScene(gender)
        for node in scene.rootNode.childNodes {
            self.sceneNode.addChildNode(node)
        }
        self.setupDefaultCameraNode()
        self.setupHeadCameraNode()
        self.sceneNode.name = kDefaultSceneNodeName
        
        self.setHair(FKAvatarHair(gender: gender))
        self.setClothes(FKAvatarClothes(gender: gender))
        self.setMotion(FKAvatarMotion(gender: gender))
        self.setSkinColor(.Default)
    }
    
    init(avatar: FKAvatar!, scene: SCNScene) {
        self.avatar = avatar
        super.init()
        for node in scene.rootNode.childNodes {
            self.sceneNode.addChildNode(node)
        }
        self.setupDefaultCameraNode()
        self.setupHeadCameraNode()
        self.sceneNode.name = kDefaultSceneNodeName
        
        self.setHair(FKAvatarHair(gender: avatar.gender))
        self.setClothes(FKAvatarClothes(gender: avatar.gender))
        self.setMotion(FKAvatarMotion(gender: avatar.gender))
        self.setSkinColor(.Default)
    }
    
    func setupDefaultCameraNode() {
        self.defaultCameraNode.name = "FKDefaultCameraNode"
        let camera = SCNCamera()
        
        self.defaultCameraNode.position = SCNVector3Make(0, -120, 45)
        self.defaultCameraNode.eulerAngles = SCNVector3Make(Float(M_PI_2), 0, 0)
        camera.yFov = 60
        camera.zFar = 300
        
        self.defaultCameraNode.camera = camera
        
        self.sceneNode.addChildNode(self.defaultCameraNode)
    }
    
    func setupHeadCameraNode() {
        self.headCameraNode.name = "FKHeadCameraNode"
        let camera = SCNCamera()
        
        self.headCameraNode.position = SCNVector3Make(25, 0, 60)
        self.headCameraNode.eulerAngles = SCNVector3Make(-Float(M_PI / 15), 0, -Float(M_PI_2))
        camera.xFov = 50
        camera.yFov = 40
        camera.zFar = 100
        
        self.headCameraNode.camera = camera
        
        self.sceneNode.childNodeWithName("Neck", recursively: true)?.addChildNode(self.headCameraNode)
    }
    
    /**
     Changes clothes at the avatar.
     */
    public func setClothes(clothes: FKAvatarClothes!) {
        if let avatar = self.avatar {
            avatar.clothes = clothes
            
            var genderString = "M"
            switch avatar.gender {
            case .Female:
                genderString = "F"
                break
            default:
                break
            }
            
            if let defaultBody = sceneNode.childNodeWithName("A_Q3_\(genderString)_Bd", recursively: true) {
                defaultBody.hidden = false
                
                if clothes.name().isEmpty == false {
                    let clothesName = clothes.name()
                    
                    let node = SCNScene(forDaeFileName: clothesName, subDirectory: clothesName).rootNode
                    defaultBody.hidden = true
                    
                    for body in sceneNode.childNodes {
                        if body.name?.rangeOfString("_S_") != nil {
                            body.removeFromParentNode()
                        }
                    }
                    
                    for body in node.childNodes {
                        if let geometry = body.geometry {
                            
                            geometry.convertContentsPathToImage()
                            
                            sceneNode.addChildNode(body)
                            body.skinner?.skeleton = defaultBody.skinner?.skeleton
                        }
                    }
                    
                    self.setSkinColor(avatar.skinColor)
                }
            }
        }
    }
    
    /**
     Changes motion at the avatar.
     */
    public func setMotion(animation: FKAvatarMotion!) {
        self.avatar?.motion = animation
        
        if let avatarNode = sceneNode.childNodeWithName("Hips", recursively: true) {
            avatarNode.removeAllAnimations()
            
            if animation.name().isEmpty == false {
                let animationName = animation.name()
                
                let node = SCNScene(forDaeFileName: animationName, subDirectory: "Motion").rootNode.childNodeWithName("Hips", recursively: true)!
                for animationKey in node.animationKeys {
                    let animation = node.animationForKey(animationKey)!
                    animation.usesSceneTimeBase = false
                    animation.repeatCount = MAXFLOAT
                    avatarNode.addAnimation(animation, forKey: animationKey)
                }
            }
        }
    }
    
    /**
     Changes hair at the avatar.
     */
    public func setHair(hair: FKAvatarHair!) {
        self.avatar?.hair = hair
        
        if let head = sceneNode.childNodeWithName("Head", recursively: true) {
            for hair in head.childNodes {
                if hair.name?.rangeOfString("_Hr_") != nil {
                    hair.removeFromParentNode()
                }
            }
            
            if hair.name().isEmpty == false {
                let hairName = hair.name()
                if let node = SCNScene(forDaeFileName: hairName, subDirectory: hairName).rootNode.childNodeWithName(hairName, recursively: true) {
                    head.addChildNode(node)
                }
            }
        }
    }
    
    /**
     Changes glasses at the avatar.
     */
    public func setGlasses(glasses: FKAvatarGlasses?) {
        self.avatar?.glasses = glasses
        
        if let head = sceneNode.childNodeWithName("Head", recursively: true) {
            for hair in head.childNodes {
                if hair.name?.rangeOfString("_Acc_") != nil {
                    hair.removeFromParentNode()
                }
            }
            
            if glasses?.name().isEmpty == false {
                let glassesName = glasses!.name()
                if let node = SCNScene(forDaeFileName: glassesName, subDirectory: glassesName).rootNode.childNodeWithName(glassesName, recursively: true) {
                    head.addChildNode(node)
                }
            }
        }
    }
    
    /**
     Changes facial at the avatar.
     We have more basic facial, the respective `weight` into the array where you can make the avatar show different facials.
     The `weight` range is 0-1.
     */
    public func setFacial(weights: [Float]) {
        if let avatar = self.avatar {
            
            var genderString = "M"
            switch avatar.gender {
            case .Female:
                genderString = "F"
                break
            default:
                break
            }
            
            if let head = sceneNode.childNodeWithName("A_Q3_\(genderString)_Hd", recursively: true) {
                let animationKey = "morpherKey"
                head.removeAnimationForKey(animationKey)
                let animationGroup = CAAnimationGroup()
                var animations: [CAAnimation] = []
                let count = min(weights.count, avatar.geometrySourcesSemanticNormal.count)
                for i in 0..<count {
                    let animation = CABasicAnimation(keyPath: "morpher.weights[\(String(i))]")
                    animation.fromValue = 0.0
                    animation.toValue = min(max(0, weights[i]), 1)
                    animations.append(animation)
                }
                animationGroup.animations = animations
                animationGroup.autoreverses = true
                animationGroup.repeatCount = MAXFLOAT
                animationGroup.duration = 1
                head.addAnimation(animationGroup, forKey: animationKey)
            }
        }
    }
    
    /**
     Changes skin color at the avatar.
     */
    public func setSkinColor(skinColor: FKSkinColor) {
        if let avatar = self.avatar  {
            avatar.skinColor = skinColor
            
            var genderString = "M"
            switch avatar.gender {
            case .Female:
                genderString = "F"
                break
            default:
                break
            }
            
            if let image = avatar.headImages[skinColor] {
                sceneNode.childNodeWithName("A_Q3_\(genderString)_Hd", recursively: true)?.geometry?.firstMaterial?.diffuse.contents = image
            }
            for bodyNode in sceneNode.childNodes {
                if bodyNode.name?.rangeOfString("_S_") != nil {
                    if let geometry = bodyNode.geometry {
                        for material in geometry.materials {
                            if material.name?.rangeOfString("_Bd") != nil {
                                if let image = avatar.bodyImages[skinColor] {
                                    material.diffuse.contents = image
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

