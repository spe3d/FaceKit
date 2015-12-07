//
//  FKAvatarManager.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/11/2.
//  Modified by Daniel on 2015/12/7.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit
import SceneKit
import AFNetworking

/**
 An `FKAvatarManager` object lets you create a scene node, including a avatar.
 An avatar manager object is usually your first interaction with the scene node.
 */
public class FKAvatarManager: NSObject {
    
    let kFaceKitErrorDomain = "FKErrorDomain"
    
    var lastAvatarScene: SCNScene?
    var lastAvatarObject: FKAvatarObject?
    
    var avatar: FKAvatar? {
        didSet {
            self.setupScene()
        }
    }
    
    /**
     Returns the shared manager object.
     */
    public static let currentManager = FKAvatarManager()
    
    /**
     The recommended way to install `FaceKit` into your APP is to place a call to `+startWithAPIKey:` in your `-application:didFinishLaunchingWithOptions:` or `-applicationDidFinishLaunching:` method.
     */
    public static func startWithAPIKey(apiKey: String!) {
        FKHTTPRequestOperationManager.defaultManager.setAPIKey(apiKey)
    }
    
    private override init() {
        
    }
    
    func setupScene() {
        if self.avatar?.gender == .Male {
            self.lastAvatarScene = SCNScene(named: "Frameworks/FaceKit_Swift.framework/avatar.scnassets/DefaultAvatar.dae")
        } else if self.avatar?.gender == .Female {
            self.lastAvatarScene = SCNScene(named: "Frameworks/FaceKit_Swift.framework/avatar.scnassets/Female_NO_Morph.dae")
        }
    }
    
    /**
     Uploads image of face, that creates the avatar node.
     */
    public func createAvatar(gender mode: FKGender, faceImage photo: UIImage!, success: ((avatarObject: FKAvatarObject)->Void)?, failure: ((error: NSError)->Void)?) {
        var parameter: [String: AnyObject] = [:]
        parameter["mode"] = mode.rawValue
        
        FKHTTPRequestOperationManager.defaultManager.POST("", parameters: parameter, constructingBodyWithBlock: { (formData: AFMultipartFormData) -> Void in
            formData.appendPartWithFileData(UIImageJPEGRepresentation(photo, 0.75)!, name: "photo", fileName: "tempPhoto.jpg", mimeType: "image/jpeg")
            }, success: { (operation, responseObject) -> Void in
                var errorObject: NSError?
                
                if let responseObject = responseObject as? [String:AnyObject] {
                    if let error = responseObject["error"] as? [String:AnyObject] {
                        if let errorCode = error["code"] as? Int {
                            if errorCode == 0 {
                                if let avatarID = responseObject["avatar_id"] as? String {
                                    self.fetchAvatar(avatarID, success: success, failure: failure)
                                }
                            }
                            else {
                                var userInfo: [NSObject: AnyObject] = [:]
                                if let message = error["message"] {
                                    userInfo[NSLocalizedDescriptionKey] = message
                                }
                                errorObject = NSError(domain: self.kFaceKitErrorDomain, code: errorCode, userInfo: userInfo)
                            }
                        }
                        else {
                            var userInfo: [NSObject: AnyObject] = [:]
                            if let message = error["message"] {
                                userInfo[NSLocalizedDescriptionKey] = message
                            }
                            errorObject = NSError(domain: self.kFaceKitErrorDomain, code: -1, userInfo: userInfo)
                        }
                    }
                    else {
                        errorObject = NSError(domain: self.kFaceKitErrorDomain, code: -1, userInfo: nil)
                    }
                }
                else {
                    errorObject = NSError(domain: self.kFaceKitErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("", comment: "")])
                }

                if let error = errorObject {
                    failure?(error: error)
                }
            }, failure: { (operation, error) -> Void in
                failure?(error: error)
        })
    }
    
    func fetchAvatar(avatarID: String, success: ((avatarObject: FKAvatarObject)->Void)?, failure: ((error: NSError)->Void)?) {
        
        FKHTTPRequestOperationManager.defaultManager.GET(avatarID, parameters: nil, success: { (operation, responseObject) -> Void in
            if let responseObject = responseObject as? [String:AnyObject] {
                if let data = responseObject["data"] as? [String: String] {
                    let avatar = FKAvatar(avatarID: avatarID, gender: .Male)
                    avatar.setupAvatar(data)
                    avatar.downloadCompleted = { ()->Void in
                        if let scene = self.lastAvatarScene {
                            self.createCustomAvatar()
                            
                            let avatarObject = FKAvatarObject(avatar: avatar, scene: scene)
                            
                            self.lastAvatarObject = avatarObject
                            success?(avatarObject: avatarObject)
                        }
                    }
                    
                    self.avatar = avatar
                }
                else {
                    var errorCode = -1
                    var userInfo: [NSObject: AnyObject]?
                    
                    if let error = responseObject["error"] as? [String: AnyObject] {
                        if let message = error["message"] as? Int {
                            userInfo = [NSLocalizedDescriptionKey: message]
                        }
                        if let code = error["code"] as? Int {
                            errorCode = code
                        }
                    }
                    
                    let error = NSError(domain: self.kFaceKitErrorDomain, code: errorCode, userInfo: userInfo)
                    
                    failure?(error: error)
                }
            }
            }, failure: { (operation, error) -> Void in
                failure?(error: error)
        })
    }
    
    func createCustomAvatar() {
        if let node = self.lastAvatarScene?.rootNode {
            if let defaultHead = node.childNodeWithName("A_Q3_M_Hd", recursively: true) {
                
                if let avatar = self.avatar {
                    
                    var targets: [SCNGeometry] = []
                    for i in 0..<avatar.geometrySourcesSemanticNormal.count {
                        var geometrySources: [SCNGeometrySource] = []
                        if let geometry = defaultHead.geometry {
                            geometrySources += geometry.geometrySourcesForSemantic(SCNGeometrySourceSemanticTexcoord)
                            geometrySources.append(avatar.geometrySourcesSemanticNormal[i])
                            geometrySources.append(avatar.geometrySourcesSemanticVertex[i])
                            
                            targets.append(SCNGeometry(sources: geometrySources, elements: geometry.geometryElements))
                        }
                    }
                    
                    if defaultHead.morpher == nil {
                        defaultHead.morpher = SCNMorpher()
                    }
                    defaultHead.morpher?.targets = targets
                    
                    defaultHead.morpher?.setWeight(1, forTargetAtIndex: 0)
                }
            }
        }
    }
}
