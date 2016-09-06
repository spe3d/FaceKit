//
//  FACPresetType.h
//  FaceKit
//
//  Created by Daniel on 2016/8/25.
//  Copyright © 2016年 Speed 3D Inc. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, FACPresetType) {
    FACPresetTypeSuit        = 1 << 0,
    FACPresetTypeAccessory   = 1 << 1,
    FACPresetTypeHair        = 1 << 2,
    FACPresetTypeMotion      = 1 << 3,
};

NSString * _Nonnull NSStringFromFACPresetType(FACPresetType type);
