//
//  FKGeometry.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel iMac on 2015/10/27.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import Foundation
import SceneKit

extension SCNGeometry {
    func convertContentsPathToImage() {
        for material in self.materials {
            if let content = material.diffuse.contents {
                if let url = content as? NSURL {
                    if let path = url.path {
                        material.diffuse.contents = UIImage(named: "avatar.scnassets/" + path)
                    }
                }
            }
            
            if let content = material.normal.contents {
                if let url = content as? NSURL {
                    if let path = url.path {
                        material.normal.contents = UIImage(named: "avatar.scnassets/" + path)
                    }
                }
            }
            
            if let content = material.specular.contents {
                if let url = content as? NSURL {
                    if let path = url.path {
                        material.specular.contents = UIImage(named: "avatar.scnassets/" + path)
                    }
                }
            }
        }
    }
}
