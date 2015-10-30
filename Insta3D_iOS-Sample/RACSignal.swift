//
//  RACSignal.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel iMac on 2015/10/19.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension RACSignal {
    func ignoreNil() -> RACSignal {
        return self.filter({ (innerValue) -> Bool in
            return innerValue != nil
        })
    }
}
