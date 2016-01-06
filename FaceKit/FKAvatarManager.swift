//
//  FKAvatarManager.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/11/2.
//  Modified by Daniel on 2016/01/06.
//  Copyright © 2015-2016年 Speed 3D Inc. All rights reserved.
//

import UIKit
import SceneKit

/**
 An `FKAvatarManager` object lets you create a scene node, including a avatar.
 An avatar manager object is usually your first interaction with the scene node.
 */
public class FKAvatarManager: NSObject {
    
    static var APIKey = ""
    
    let kFaceKitErrorDomain = "FKErrorDomain"
    
    var lastAvatarObject: FKAvatarObject?
    
    var avatar: FKAvatar?
    
    /**
     Returns the shared manager object.
     */
    public static let currentManager = FKAvatarManager()
    
    /**
     The recommended way to install `FaceKit` into your APP is to place a call to `+startWithAPIKey:` in your `-application:didFinishLaunchingWithOptions:` or `-applicationDidFinishLaunching:` method.
     */
    public static func startWithAPIKey(apiKey: String!) {
        FKAvatarManager.APIKey = apiKey
    }
    
    private override init() {
        
    }
    
    /**
     Uploads image of face, that creates the avatar node.
     */
    public func createAvatar(gender mode: FKGender, faceImage photo: UIImage!, success: ((avatarObject: FKAvatarObject)->Void)?, failure: ((error: NSError)->Void)?) {
        var parameter: [String: String] = [:]
        parameter["mode"] = mode.rawValue
        
        let request = FKMutableURLRequest(path: "")
        request.HTTPMethod = "POST"
        request.setHTTPParameters(parameter, image: photo)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let error = error {
                failure?(error: error)
                return
            }

            guard let data = data else {
                failure?(error: NSError(domain: self.kFaceKitErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Have not response data", comment: "")]))
                return
            }
            
            guard let responseObject = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                failure?(error: NSError(domain: self.kFaceKitErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("response data is not JSON", comment: "")]))
                return
            }
            
            guard let error = responseObject?["error"] as? [String: AnyObject] else {
                failure?(error: NSError(domain: self.kFaceKitErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("error information not found", comment: "")]))
                return
            }
            
            var errorCode = -1
            if let code = error["code"] as? Int {
                errorCode = code
            }
            
            if errorCode != 0 {
                var userInfo: [NSObject: AnyObject] = [:]
                if let message = error["message"] {
                    userInfo[NSLocalizedDescriptionKey] = message
                }
                failure?(error: NSError(domain: self.kFaceKitErrorDomain, code: errorCode, userInfo: userInfo))
                return
            }
            
            guard let avatarID = responseObject?["avatar_id"] as? String else {
                failure?(error: NSError(domain: self.kFaceKitErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("avatar id not found", comment: "")]))
                return
            }
            
            self.fetchAvatar(avatarID, success: success, failure: failure)
        }
        
        task.resume()
    }
    
    func fetchAvatar(avatarID: String, success: ((avatarObject: FKAvatarObject)->Void)?, failure: ((error: NSError)->Void)?) {
        
        let request = FKMutableURLRequest(path: avatarID)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let error = error {
                failure?(error: error)
                return
            }
            
            guard let data = data else {
                failure?(error: NSError(domain: self.kFaceKitErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Have not response data", comment: "")]))
                return
            }
            
            guard let responseObject = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                failure?(error: NSError(domain: self.kFaceKitErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("response data is not JSON", comment: "")]))
                return
            }
            
            guard let avatarData = responseObject?["data"] as? [String: String] else {
                var errorCode = -1
                var userInfo: [NSObject: AnyObject]?

                if let error = responseObject?["error"] as? [String: AnyObject] {
                    if let message = error["message"] as? Int {
                        userInfo = [NSLocalizedDescriptionKey: message]
                    }
                    if let code = error["code"] as? Int {
                        errorCode = code
                    }
                }

                let error = NSError(domain: self.kFaceKitErrorDomain, code: errorCode, userInfo: userInfo)
                
                failure?(error: error)
                return
            }
            
            let avatar = FKAvatar(avatarID: avatarID, gender: .Male)
            avatar.setupAvatar(avatarData)
            avatar.downloadCompleted = { ()->Void in
                
                let avatarObject = FKAvatarObject(avatar: avatar)

                self.lastAvatarObject = avatarObject
                success?(avatarObject: avatarObject)
            }
            
            self.avatar = avatar
        }
        
        task.resume()
    }
}
