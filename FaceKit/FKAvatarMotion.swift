//
//  FKAvatarMotion.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/26.
//  Modified by Daniel on 2015/12/1.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit

/**
 An instance of the `FKAvatarMotion` class implements a motion on the avatar.
 You can use this class to motion, such as those you might let your avatar dancing.
 */
public class FKAvatarMotion: NSObject {

    let defaultMotion = [
        FKGender.Male: ["M_M_0000", "M_M_0001", "M_M_0002", "M_M_0003", "M_M_0004", "M_M_0005"],
        FKGender.Female: ["M_F_0000", "M_F_0001", "M_F_0002", "M_F_0003", "M_F_0004", "M_F_0005"]
    ]
    
    var motionName = ""
    
    /**
     Creates random a motion of avatar from a gender of avatar.
     
     - Parameters:
        - gender: Gender of Avatar
     */
    public init(gender: FKGender) {
        super.init()
        
        if FKRandom.generate() {
            if let motionNames = defaultMotion[gender] {
                if !motionNames.isEmpty {
                    self.motionName = motionNames[FKRandom.within(0..<motionNames.count)]
                }
            }
        }
    }
    
    /**
     Creates the motion of avatar from a gender of avatar and motion ID.
     
     TODO: `init(gender: FKGender, number: Int)` changes to find motion's DAE file from CloudKit or Amazon S3.
     
     - Parameters:
        - gender: Gender of Avatar
        - number: The motion ID
     */
    public init(gender: FKGender, number: Int) {
        super.init()
        
        self.motionName = "M_"
        if gender == .Male {
            self.motionName += "M_"
        }
        else if gender == .Female {
            self.motionName += "F_"
        }
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.minimumIntegerDigits = 4
        
        self.motionName += numberFormatter.stringFromNumber(number)!
    }
    
    /**
     Get the name of avatar's motion.
     */
    public func name()->String {
        return self.motionName
    }

}
