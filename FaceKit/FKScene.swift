//
//  FKScene.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/12/8.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import Foundation
import SceneKit

extension SCNScene {
    convenience init(forDaeFileName daeFileName: String!, subDirectory: String?) {
        var directory = "avatar.scnassets"
        
        if let subDirectory = subDirectory {
            if !subDirectory.isEmpty {
                directory += "/\(subDirectory)"
            }
        }
        
        let bundle = NSBundle(forClass: FKAvatarManager.self)
        if let daeFileURL = bundle.URLForResource(daeFileName, withExtension: "dae", subdirectory: directory) {
            do {
                try self.init(URL: daeFileURL, options: nil)
            }
            catch {
                fatalError("[SPE Error] avatar.scnassets not found")
            }
        }
        else {
            fatalError("[SPE Error] avatar.scnassets or \(daeFileName).dae not found")
        }
    }
}
