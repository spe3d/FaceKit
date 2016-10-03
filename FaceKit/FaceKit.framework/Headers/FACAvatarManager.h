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

/*!
 An `FACAvatarManager` object lets you create a scene node, including a avatar.
 An avatar manager object is usually your first interaction with the scene node.
 */
@interface FACAvatarManager : NSObject

/*!
 Returns the shared manager object.
 */
+ (nonnull FACAvatarManager *)currentManager;

/*!
 @method getLandmarksWithFaceImage:successBlock:failureBlock:
 
 @discussion
     Use an image to create the landmarks for the face. And get the landmark information.
 
 @param faceImage
 The image must contain a face. This face to occupy 80% of the image.
 
 @param successBlock
 The block to execute after the landmarks get. The block has no return value. The block will be passed an NSArray object containing NSValue objects which contain CGPoint.
 
 @param failureBlock
 The block to execute failure. The block will be passed an NSError object if the landmarks could not be created.
 */
- (void)getLandmarksWithFaceImage:(nonnull UIImage *)image successBlock:(void(^ _Nullable)(NSArray<NSValue *> * _Nonnull avatarController))success failureBlock:(void(^ _Nullable)(NSError * _Nonnull error))failure;

/*!
 Uploads image of face, that creates the avatar node.
 */
- (void)createAvatarWithGender:(FACGender)gender faceImage:(nonnull UIImage *)image successBlock:(void(^ _Nullable)(FACAvatarController * _Nonnull avatarController))success failureBlock:(void(^ _Nullable)(NSError * _Nonnull error))failure;

- (void)createAvatarWithGender:(FACGender)gender faceImage:(nonnull UIImage *)image fixLandmarks:(nullable NSArray<NSValue *>*)fixLandmarks successBlock:(void(^ _Nullable)(FACAvatarController * _Nonnull avatarController))success failureBlock:(void(^ _Nullable)(NSError * _Nonnull error))failure;


@end
