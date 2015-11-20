//
//  FKAvatarHair.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/26.
//  Modified by Daniel on 2015/11/12.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit

/**
 An hair of avatar.
 */
public class FKAvatarHair: NSObject {

    let defaultHair = [
        FKGender.Male: ["H_Q3_M_Hr_0001", "H_Q3_M_Hr_0009", "H_Q3_M_Hr_5000", "H_Q3_M_Hr_6002", "H_Q3_M_Hr_6525"],
        FKGender.Female: ["H_Q3_F_Hr_0011", "H_Q3_F_Hr_0030", "H_Q3_F_Hr_5000", "H_Q3_F_Hr_5001"]
    ]
    
    var hairName = ""
    
    /**
     Creates random a hair of avatar from gender of avatar.
     
     - Parameters:
        - gender: Gender of avatar
     */
    public init(gender: FKGender) {
        super.init()
        
        if let hairNames = defaultHair[gender] {
            if !hairNames.isEmpty {
                self.hairName = hairNames[FKRandom.within(0..<hairNames.count)]
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
     Get the name of avatar's hair.
     */
    public func name()->String {
        return self.hairName;
    }
}
