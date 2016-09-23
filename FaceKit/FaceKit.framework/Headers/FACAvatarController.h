//
//  FACAvatarController.h
//  FaceKit
//
//  Created by LeeHao on 2016/8/29.
//  Copyright © 2016年 Speed 3D Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FACGender.h"
#import <SceneKit/SceneKit.h>
#import "FACPreset.h"


/**
 An `FACAvatarController` class has a node of the avatar on a scene graph.
 You have to show the avatar, you need to add `sceneNode` in your scene.
 To modify style on the avatar, use methods of `FACAvatarController` can immediately to update on the `sceneNode`.
 
 Save an Avatar
 
 FaceKit provides to save an avatar to a file.
 `FACAvatarController` class support the `NSSecureCoding` protocol.
 Use the `NSKeyedArchiver` class to serialize an avatar and all its contents, and the `NSKeyedUnarchiver` class to load an archived avatar.
 */
@interface FACAvatarController : NSObject <NSSecureCoding>

@property(nonatomic) FACGender avatarGender;

/**
 Returns a Boolean value indicating whether the scene node wears preset.
 */
@property(nonatomic, readonly) BOOL isWornPresets;

/**
 The node of the avatar on the scene graph.
 */
@property(nonatomic, strong, nonnull) SCNNode *sceneNode;

/**
 Create a default avatar.
 */
- (nonnull instancetype)initWithGenderOfDefaultAvatar:(FACGender)gender;


- (void)observeAvatarHasWornPresets:(void (^ _Nonnull)(SCNNode * _Nonnull node))completed;


+ (nonnull SCNNode *)getDefaultCameraNode;


- (NSInteger)version;

- (void)setSuit:(nonnull FACPreset *)suit completionHandler:(void (^ _Nullable)(BOOL success, NSError * _Nullable error))block;

- (void)setMotion:(nonnull FACPreset *)motion completionHandler:(void (^ _Nullable)(BOOL success, NSError * _Nullable error))block;

- (void)setHair:(nonnull FACPreset *)hair completionHandler:(void (^ _Nullable)(BOOL success, NSError * _Nullable error))block;

- (void)setAccessory:(nullable FACPreset *)accessory completionHandler:(void (^ _Nullable)(BOOL success, NSError * _Nullable error))block;

/**
 Changes facial at the avatar.
 We have more basic facial, the respective `weight` into the array where you can make the avatar show different facials.
 The `weight` range is 0-1.
 */
- (void)setFacialWithWeights:(nonnull NSArray <NSNumber *> *)weights;

@end
