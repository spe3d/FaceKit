//
//  FKHTTPRequestOperationManager.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/17.
//  Modified by Daniel on 2015/12/2.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit
import AFNetworking

private let FK_Platform = "iOS"

class FKHTTPRequestOperationManager: AFHTTPRequestOperationManager {
    
    static let defaultManager: FKHTTPRequestOperationManager = {
        let manager = FKHTTPRequestOperationManager(baseURL: NSURL(string: "http://api.spe3d.co/v3/avatar"))
        
        let requestSerializer = AFHTTPRequestSerializer()
        requestSerializer.setValue(FK_Platform, forHTTPHeaderField: "Insta3D-Platform")
        
        manager.requestSerializer = requestSerializer
        
        return manager
    }()
    
    func setAPIKey(APIKey: String!) {
        self.requestSerializer.setValue(APIKey, forHTTPHeaderField: "Insta3D-API-Key")
    }
}

