//
//  FACAvatarManager.h
//  FaceKit
//
//  Created by LeeHao on 2016/8/28.
//  Copyright © 2016年 Speed 3D Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FACGender.h"
#import "FACAvatarController.h"

#define kFaceKitErrorDomain  @"FACErrorDomain"

/**
 An `FACAvatarManager` object lets you create a scene node, including a avatar.
 An avatar manager object is usually your first interaction with the scene node.
 */
@interface FACAvatarManager : NSObject

/**
 Returns the shared manager object.
 */
+ (nonnull FACAvatarManager *)currentManager;


/**
 Uploads image of face, that creates the avatar node.
 */
- (void)createAvatarWithGender:(FACGender)gender faceImage:(nonnull UIImage *)image successBlock:(void(^ _Nullable)(FACAvatarController * _Nonnull avatarController))success failureBlock:(void(^ _Nullable)(NSError * _Nonnull error))failure;


@end
