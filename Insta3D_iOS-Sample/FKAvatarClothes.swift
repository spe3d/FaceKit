//
//  FKAvatarClothes.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/26.
//  Modified by Daniel on 2015/11/12.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit

/**
 An clothes of avatar.
 */
public class FKAvatarClothes: NSObject {

    let defaultClothes = [
        FKGender.Male: ["A_Q3_M_S_0002", "A_Q3_M_S_0009", "A_Q3_M_S_5000", "A_Q3_M_S_5008", "A_Q3_M_S_6006"],
        FKGender.Female: ["A_Q3_F_S_3001", "A_Q3_F_S_3002", "A_Q3_F_S_3006", "A_Q3_F_S_3014"]
    ]
    
    var clothesName = ""
    
    /**
     Creates random a clothes of avatar from a gender of avatar.
     
     - Parameters:
        - gender: Gender of Avatar
     */
    public init(gender: FKGender) {
        super.init()
        
        if let clothesNames = defaultClothes[gender] {
            if !clothesNames.isEmpty {
                self.clothesName = clothesNames[FKRandom.within(0..<clothesNames.count)]
            }
        }
    }
    
    /**
     Creates the clothes of avatar from a gender of avatar and clothes ID.
     
     TODO: `init(gender: FKGender, number: Int)` changes to find clothes's DAE file from CloudKit or Amazon S3.
     
     - Parameters:
        - gender: Gender of Avatar
        - number: The clothes ID
     */
    public init(gender: FKGender, number: Int) {
        super.init()
        
        self.clothesName = "A_Q3_"
        if gender == .Male {
            self.clothesName += "M_"
        }
        else if gender == .Female {
            self.clothesName += "F_"
        }
        self.clothesName += "S_"
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.minimumIntegerDigits = 4
        
        self.clothesName += numberFormatter.stringFromNumber(number)!
    }
    
    /**
     Get the name of avatar's clothes.
     */
    public func name()->String {
        return self.clothesName
    }

}
