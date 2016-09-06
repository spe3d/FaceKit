//
//  FACGender.h
//  FaceKit
//
//  Created by Daniel on 2016/8/25.
//  Copyright © 2016年 Speed 3D Inc. All rights reserved.
//

typedef NS_ENUM(NSUInteger, FACGender) {
    FACGenderMale = 0,
    FACGenderFemale = 1,
};

NSString * _Nonnull NSStringFromFACGender(FACGender gender);
