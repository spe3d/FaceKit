//
//  FKAvatarGlasses.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/11/11.
//  Modified by Daniel on 2016/01/04.
//  Copyright © 2015-2016年 Speed 3D Inc. All rights reserved.
//

import UIKit

/**
 An instance of the `FKAvatarGlasses` class implements a glasses on the avatar.
 You can use this class to wear glasses, such as those you might let your avatar in glesses.
 */
public class FKAvatarGlasses: NSObject, NSSecureCoding {

    let defaultGlasses = [
        FKGender.Male: ["B_Q3_M_Acc_0000", "B_Q3_M_Acc_0001", "B_Q3_M_Acc_0002", "B_Q3_M_Acc_0003", "B_Q3_M_Acc_0004"],
        FKGender.Female: ["B_Q3_F_Acc_5003", "B_Q3_F_Acc_5005", "B_Q3_F_Acc_5006", "B_Q3_F_Acc_5007"]
    ]
    
    var glassesName = ""
    let kGlassesName = "glassesName"
    
    /**
     Creates random a clothes of avatar from a gender of avatar.
     */
    public init(gender: FKGender, random: Bool = false) {
        super.init()
        
        if random {
            if let glassesNames = defaultGlasses[gender] {
                if !glassesNames.isEmpty {
                    self.glassesName = glassesNames[FKRandom.within(0..<glassesNames.count)]
                }
            }
        }
    }
    
    /**
     Creates the glasses of avatar from a gender of avatar and glasses ID.
     
     TODO: `init(gender: FKGender, number: Int)` changes to find glasses' DAE file from CloudKit or Amazon S3.
     
     - Parameters:
     - gender: Gender of Avatar
     - number: The glasses ID
     */
    public init(gender: FKGender, number: Int) {
        super.init()
        
        self.glassesName = "B_Q3_"
        if gender == .Male {
            self.glassesName += "M_"
        }
        else if gender == .Female {
            self.glassesName += "F_"
        }
        self.glassesName += "Acc_"
        self.glassesName += String(number)
    }
    
    /**
     Returns an object initialized from data in a given unarchiver.
     */
    required public init(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObjectOfClass(NSString.self, forKey: self.kGlassesName) as? String {
            self.glassesName = name
        }
        super.init()
    }
    
    /**
     Encodes the receiver using a given archiver.
     */
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.glassesName, forKey: self.kGlassesName)
    }
    
    /**
     Returns the class supports secure coding.
     */
    public static func supportsSecureCoding() -> Bool {
        return true
    }
    
    /** Get the name of avatar's clothes.
     */
    public func name()->String {
        return self.glassesName
    }
}
