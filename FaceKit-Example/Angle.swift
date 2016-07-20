//
//  Angle.swift
//  FaceKit
//
//  Created by Daniel iMac on 2016/1/26.
//  Copyright © 2016年 Speed 3D Inc. All rights reserved.
//

import Foundation
import CoreGraphics

extension Int {
    var radian: Double { return Double(self) / 180 * M_PI }
    
    var degree: Double { return Double(self) * 180 / M_PI }
}

extension Float {
    var radian: Double { return Double(self) / 180 * M_PI }
    
    var degree: Double { return Double(self) * 180 / M_PI }
}

extension Double {
    var radian: Double { return self / 180 * M_PI }
    
    var degree: Double { return self * 180 / M_PI }
}

extension CGFloat {
    var radian: Double { return Double(self) / 180 * M_PI }
    
    var degree: Double { return Double(self) * 180 / M_PI }
}
