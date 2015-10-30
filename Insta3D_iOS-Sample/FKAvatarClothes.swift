//
//  FKAvatarClothes.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel iMac on 2015/10/26.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit

/** An clothes of avatar.
 
 TODO: Create initialization by `init(name: String)` what find clothes's DAE file from CloudKit or Amazon S3.
 */
public class FKAvatarClothes: NSObject {

    let defaultClothes = [
        FKGender.Male: ["A_Q3_M_S_0002", "A_Q3_M_S_5000"],
        FKGender.Female: ["A_Q3_F_S_3001", "A_Q3_F_S_3002", "A_Q3_F_S_3006", "A_Q3_F_S_3014"]
    ]
    
    var clothesName = ""
    
    /** Creates random a clothes of avatar from a gender of avatar.
     */
    public init(gender: FKGender) {
        super.init()
        
        if let clothesNames = defaultClothes[gender] {
            if !clothesNames.isEmpty {
                self.clothesName = clothesNames[FKRandom.within(0..<clothesNames.count)]
            }
        }
    }
    
    init(name: String) {
        super.init()
        
        self.clothesName = name
    }
    
    /** Get the name of avatar's clothes.
     */
    public func name()->String {
        return self.clothesName
    }

}
