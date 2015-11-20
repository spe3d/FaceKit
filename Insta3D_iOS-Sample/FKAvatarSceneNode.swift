//
//  FKAvatarSceneNode.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/11/9.
//  Modified by Daniel on 2015/11/12.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit
import SceneKit

/**
 An `FKAvatarSceneNode` object is a node in a scene graph that include the avatar.
 */
public class FKAvatarSceneNode: SCNNode {
    let avatar: FKAvatar?
    
    init(avatar: FKAvatar!) {
        self.avatar = avatar
        super.init()
        self.name = "FKAvatarNode"
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Changes clothes at the avatar.
     */
    public func setClothes(clothes: FKAvatarClothes!) {
        self.avatar?.clothes = clothes
        
        if let defaultBody = self.childNodeWithName("A_Q3_M_Bd", recursively: true) {
            defaultBody.hidden = false
            
            if clothes.name().isEmpty == false {
                let clothesName = clothes.name()
                
                if let node = SCNScene(named: "avatar.scnassets/\(clothesName)/\(clothesName).DAE")?.rootNode {
                    defaultBody.hidden = true
                    
                    for body in self.childNodes {
                        if body.name?.rangeOfString("_S_") != nil {
                            body.removeFromParentNode()
                        }
                    }
                    
                    for body in node.childNodes {
                        if let geometry = body.geometry {
                            
                            geometry.convertContentsPathToImage()
                            
                            self.addChildNode(body)
                            body.skinner?.skeleton = defaultBody.skinner?.skeleton
                        }
                    }
                }
            }
        }
    }
    
    /**
     Changes motion at the avatar.
     */
    public func setMotion(animation: FKAvatarMotion!) {
        self.avatar?.motion = animation
        
        if let avatarNode = self.childNodeWithName("Hips", recursively: true) {
            avatarNode.removeAllAnimations()
            
            if animation.name().isEmpty == false {
                let animationName = animation.name()
                let node = SCNScene(named: "avatar.scnassets/Motion/\(animationName).DAE")!.rootNode.childNodeWithName("Hips", recursively: true)!
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
        
        if let head = self.childNodeWithName("Head", recursively: true) {
            for hair in head.childNodes {
                if hair.name?.rangeOfString("_Hr_") != nil {
                    hair.removeFromParentNode()
                }
            }
            
            if hair.name().isEmpty == false {
                let hairName = hair.name()
                if let node = SCNScene(named: "avatar.scnassets/\(hairName)/\(hairName).DAE")?.rootNode.childNodeWithName(hairName, recursively: true) {
                    head.addChildNode(node)
                }
            }
        }
    }
}
