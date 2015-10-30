//
//  FKHTTPRequestOperationManager.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/17.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit
import AFNetworking
import FaceKit

private let FK_API_KEY = <#T##Insert your API key#>
private let FK_Platform = "iOS"

public class FKHTTPRequestOperationManager: AFHTTPRequestOperationManager {
    
    public class func currentManager()->FKHTTPRequestOperationManager {
        struct Static {
            static var current: FKHTTPRequestOperationManager? = nil
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.current = FKHTTPRequestOperationManager(baseURL: NSURL(string: "http://api.spe3d.co/v3/avatar"))
            
            let requestSerializer = AFHTTPRequestSerializer()
            requestSerializer.setValue(FK_API_KEY, forHTTPHeaderField: "Insta3D-API-Key")
            requestSerializer.setValue(FK_Platform, forHTTPHeaderField: "Insta3D-Platform")
            
            Static.current!.requestSerializer = requestSerializer
        })
        return Static.current!
    }
    
    public func createAvatar(mode: FKGender, photo: UIImage, success: ((operation: AFHTTPRequestOperation, responseObject: AnyObject) -> Void)?, failure: ((operation: AFHTTPRequestOperation, error: NSError) -> Void)?) {
        var parameter: [String: AnyObject] = [:]
        parameter["mode"] = mode.rawValue
        
        self.POST("", parameters: parameter, constructingBodyWithBlock: { (formData: AFMultipartFormData) -> Void in
            formData.appendPartWithFileData(UIImageJPEGRepresentation(photo, 0.75)!, name: "photo", fileName: "tempPhoto.jpg", mimeType: "image/jpeg")
            }, success: success, failure: failure)
    }
    
    public func getAvatar(avatarId: String, success: ((operation: AFHTTPRequestOperation, responseObject: AnyObject) -> Void)?, failure: ((operation: AFHTTPRequestOperation, error: NSError) -> Void)?) {
        
        self.GET(avatarId, parameters: nil, success: success, failure: failure)
    }
}

