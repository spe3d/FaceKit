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

extension FKAvatarController {
    func getHeadCameraNode() -> SCNNode {
        let node = SCNNode()
        
        let camera = SCNCamera()
        
        node.position = SCNVector3Make(22.377, -0.059, 37.138)
        node.eulerAngles = SCNVector3Make(Float(-M_PI) / 20, 0, Float(-M_PI_2))
        
        node.camera = camera
        
        return node
    }
}
