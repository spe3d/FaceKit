//
//  FKAvatarHair.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/26.
//  Modified by Daniel on 2016/01/04.
//  Copyright © 2015-2016年 Speed 3D Inc. All rights reserved.
//

import UIKit

/**
 An instance of the `FKAvatarHair` class implements a hair on the avatar.
 You can use this class to hair design, such as those you might dress up your hair.
 */
public class FKAvatarHair: NSObject, NSSecureCoding {

    let defaultHair = [
        FKGender.Male: ["H_Q3_M_Hr_5000", "H_Q3_M_Hr_0001", "H_Q3_M_Hr_0009", "H_Q3_M_Hr_6002", "H_Q3_M_Hr_6525"],
        FKGender.Female: ["H_Q3_F_Hr_5000", "H_Q3_F_Hr_0011", "H_Q3_F_Hr_0030", "H_Q3_F_Hr_5001"]
    ]
    
    var hairName = ""
    let kHairName = "hairName"
    
    /**
     Creates random a hair of avatar from gender of avatar.
     
     - Parameters:
        - gender: Gender of Avatar
        - random: Using a Random Hair
     */
    public init(gender: FKGender, random: Bool = false) {
        super.init()
        
        if let hairNames = defaultHair[gender] {
            if !hairNames.isEmpty {
                if random {
                    self.hairName = hairNames[FKRandom.within(0..<hairNames.count)]
                }
                else {
                    self.hairName = hairNames[0]
                }
            }
        }
    }
    
    /**
     Creates the hair of avatar from a gender of avatar and hair ID.
     
     TODO: `init(gender: FKGender, number: Int)` changes to find hair's DAE file from CloudKit or Amazon S3.
     
     - Parameters:
        - gender: Gender of Avatar
        - number: The hair ID
     */
    public init(gender: FKGender, number: Int) {
        super.init()
        
        self.hairName = "H_"
        if gender == .Male {
            self.hairName += "M_"
        }
        else if gender == .Female {
            self.hairName += "F_"
        }
        self.hairName += "Hr_"
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.minimumIntegerDigits = 4
        
        self.hairName += numberFormatter.stringFromNumber(number)!
    }
    
    /**
     Returns an object initialized from data in a given unarchiver.
     */
    required public init(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObjectOfClass(NSString.self, forKey: self.kHairName) as? String {
            self.hairName = name
        }
        super.init()
    }
    
    /**
     Encodes the receiver using a given archiver.
     */
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.hairName, forKey: self.kHairName)
    }
    
    /**
     Returns the class supports secure coding.
     */
    public static func supportsSecureCoding() -> Bool {
        return true
    }
    
    /**
     Get the name of avatar's hair.
     */
    public func name()->String {
        return self.hairName;
    }
}
