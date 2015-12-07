//
//  FKRandom.swift
//  Insta3D_iOS-Sample
//
//  Created by Daniel on 2015/10/26.
//  Modified by Daniel on 2015/11/5.
//  Copyright © 2015年 Speed 3D Inc. All rights reserved.
//

import Foundation

struct FKRandom {
    static func within<B: protocol<Comparable, ForwardIndexType>>(range: ClosedInterval<B>) -> B {
        let inclusiveDistance = range.start.distanceTo(range.end).successor()
        let randomAdvance = B.Distance(arc4random_uniform(UInt32(inclusiveDistance.toIntMax())).toIntMax())
        return range.start.advancedBy(randomAdvance)
    }
    
    static func within(range: HalfOpenInterval<Int>)->Int {
        let inclusiveDistance = range.start.distanceTo(range.end-1).successor()
        let randomAdvance = Int.Distance(arc4random_uniform(UInt32(inclusiveDistance.toIntMax())).toIntMax())
        return range.start.advancedBy(randomAdvance)
    }
    
    static func within(range: ClosedInterval<Float>) -> Float {
        return (range.end - range.start) * Float(Float(arc4random()) / Float(UInt32.max)) + range.start
    }
    
    static func within(range: ClosedInterval<Double>) -> Double {
        return (range.end - range.start) * Double(Double(arc4random()) / Double(UInt32.max)) + range.start
    }
    
    static func generate() -> Int {
        return FKRandom.within(0...1)
    }
    
    static func generate() -> Bool {
        return FKRandom.generate() == 0
    }
    
    static func generate() -> Float {
        return FKRandom.within(0.0...1.0)
    }
    
    static func generate() -> Double {
        return FKRandom.within(0.0...1.0)
    }
}
