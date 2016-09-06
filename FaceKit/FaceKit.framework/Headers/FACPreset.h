//
//  FACPreset.h
//  FaceKit
//
//  Created by Daniel on 2016/8/25.
//  Copyright © 2016年 Speed 3D Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FACPresetType.h"
#import "FACGender.h"

@interface FACPreset: NSObject

@property(nonatomic, assign) FACPresetType type;
@property(nonatomic, assign) FACGender gender;
@property(nonnull, nonatomic, strong, readonly) NSString *name;

- (nonnull instancetype)initWithType:(FACPresetType)type gender:(FACGender)gender;
- (nonnull instancetype)initWithType:(FACPresetType)type gender:(FACGender)gender name:(nullable NSString *)name;

+ (nonnull NSArray<FACPreset *> *)getPresetsForType:(FACPresetType)type gender:(FACGender)gender;

- (void)observePreviewImage:(nonnull void (^)(FACPreset * _Nonnull preset,  UIImage * _Nonnull image))block;

@end
