//
//  FKAvatarGlasses.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/11/11.
//  Modified by Daniel on 2015/12/21.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit

/**
 An instance of the `FKAvatarGlasses` class implements a glasses on the avatar.
 You can use this class to wear glasses, such as those you might let your avatar in glesses.
 */
public class FKAvatarGlasses: NSObject {

    let defaultGlasses = [
        FKGender.Male: ["B_Q3_M_Acc_0000", "B_Q3_M_Acc_0001", "B_Q3_M_Acc_0002", "B_Q3_M_Acc_0003", "B_Q3_M_Acc_0004"],
        FKGender.Female: ["B_Q3_F_Acc_5003", "B_Q3_F_Acc_5005", "B_Q3_F_Acc_5006", "B_Q3_F_Acc_5007"]
    ]
    
    var glassesName = ""
    
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
    
    /** Get the name of avatar's clothes.
     */
    public func name()->String {
        return self.glassesName
    }
}
