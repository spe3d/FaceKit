//
//  SPEAvatarController.swift
//  FaceKit
//
//  Created by Daniel on 2016/4/25.
//  Copyright © 2016年 Speed 3D Inc. All rights reserved.
//

import Foundation
import FaceKit
import SceneKit

extension FACAvatarController {
    func getHeadCameraNode() -> SCNNode {
        let node = SCNNode()
        
        let camera = SCNCamera()
        
        node.position = SCNVector3Make(-2.684, -0.388, 185.154)
        node.eulerAngles = SCNVector3Make(Float(5.148.radian), Float(-0.002.radian), Float(-89.998.radian))
        
        camera.yFov = 11.3
        camera.zFar = 1000
        
        node.camera = camera
        
        return node
    }
    
    func getBustCameraNode() -> SCNNode {
        let node = SCNNode()
        
        let camera = SCNCamera()
        
        node.position = SCNVector3Make(-0.021, 166.002, 729.037)
        
        camera.yFov = 11
        camera.zFar = 1000
        
        node.camera = camera
        
        return node
    }
}
