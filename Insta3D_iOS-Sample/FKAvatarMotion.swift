//
//  FKAvatarMotion.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel iMac on 2015/10/26.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit

/** An motion of avatar.
 
 TODO: Create initialization by `init(name: String)` what find motion's DAE file from CloudKit or Amazon S3.
 */
public class FKAvatarMotion: NSObject {

    let defaultMotion = [
        FKGender.Male: ["dance_motion"],
        FKGender.Female: []
    ]
    
    var motionName = ""
    
    /** Creates random a motion of avatar from a gender of avatar.
     */
    public init(gender: FKGender) {
        super.init()
        
//        if FKRandom.generate() {
            if let motionNames = defaultMotion[gender] {
                if !motionNames.isEmpty {
                    self.motionName = motionNames[FKRandom.within(0..<motionNames.count)]
                }
            }
//        }
    }
    
    init(name: String) {
        super.init()
        
        self.motionName = name
    }
    
    /** Get the name of avatar's motion.
     */
    public func name()->String {
        return self.motionName
    }

}
