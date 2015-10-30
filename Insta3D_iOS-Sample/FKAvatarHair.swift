//
//  FKAvatarHair.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel iMac on 2015/10/26.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import UIKit

/** An hair of avatar.
 
 TODO: Create initialization by `init(name: String)` what find hair's DAE file from CloudKit or Amazon S3.
 */
public class FKAvatarHair: NSObject {

    let defaultHair = [
        FKGender.Male: ["H_Q3_M_Hr_6525"],
        FKGender.Female: []
    ]
    
    var hairName = ""
    
    /** Creates random a hair of avatar from a gender of avatar.
     */
    public init(gender: FKGender) {
        super.init()
        
//        if FKRandom.generate() {
            if let hairNames = defaultHair[gender] {
                if !hairNames.isEmpty {
                    self.hairName = hairNames[FKRandom.within(0..<hairNames.count)]
                }
            }
//        }
    }
    
    init(name: String) {
        super.init()
        
        self.hairName = name
    }
    
    /** Get the name of avatar's hair.
     */
    public func name()->String {
        return self.hairName;
    }
}
