//
//  FKAvatarMotion.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/26.
//  Modified by Daniel on 2016/01/04.
//  Copyright © 2015-2016年 Speed 3D Inc. All rights reserved.
//

import UIKit

/**
 An instance of the `FKAvatarMotion` class implements a motion on the avatar.
 You can use this class to motion, such as those you might let your avatar dancing.
 */
public class FKAvatarMotion: NSObject, NSSecureCoding {

    let defaultMotion = [
        FKGender.Male: ["M_M_0000", "M_M_0001", "M_M_0002", "M_M_0003", "M_M_0004", "M_M_0005"],
        FKGender.Female: ["M_F_0000", "M_F_0001", "M_F_0002", "M_F_0003", "M_F_0004", "M_F_0005"]
    ]
    
    var motionName = ""
    let kMotionName = "motionName"
    
    /**
     Creates random a motion of avatar from a gender of avatar.
     
     - Parameters:
        - gender: Gender of Avatar
        - random: Using a Random Motion
     */
    public init(gender: FKGender, random: Bool = false) {
        super.init()
        
        if let motionNames = defaultMotion[gender] {
            if !motionNames.isEmpty {
                if random {
                    self.motionName = motionNames[FKRandom.within(0..<motionNames.count)]
                }
                else {
                    self.motionName = motionNames[0]
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
     Returns an object initialized from data in a given unarchiver.
     */
    required public init(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObjectOfClass(NSString.self, forKey: self.kMotionName) as? String {
            self.motionName = name
        }
        super.init()
    }
    
    /**
     Encodes the receiver using a given archiver.
     */
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.motionName, forKey: self.kMotionName)
    }
    
    /**
     Returns the class supports secure coding.
     */
    public static func supportsSecureCoding() -> Bool {
        return true
    }
    
    /**
     Get the name of avatar's motion.
     */
    public func name()->String {
        return self.motionName
    }

}
