//
//  FaceKit.h
//  FaceKit
//
//  Created by 撒景賢 on 10/29/15.
//  Copyright © 2015 Speed 3D Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FaceKit/FACAvatarManager.h>
#import <FaceKit/FACAvatarController.h>
#import <FaceKit/FACGender.h>
#import <FaceKit/FACPreset.h>
#import <FaceKit/FACPresetType.h>


@interface FaceKit : NSObject

//! The FaceKit API Key for this app
@property(nonatomic, strong, readonly, nullable) NSString *APIKey;

//! Project version string for FaceKit.
@property(nonatomic, readonly, nonnull) NSString *version;


/**
 The recommended way to install `FaceKit` into your APP is to place a call to `+startWithAPIKey:` in your `-application:didFinishLaunchingWithOptions:` or `-applicationDidFinishLaunching:` method.
 
 @param apiKey The FaceKit API Key for this app
 */
+ (void)startWithAPIKey:(nonnull NSString *)apiKey;

/**
 Access the singleton FaceKit instance.
 
 @return The singleton FaceKit instance
 */
+ (nonnull FaceKit *)sharedInstance;

@end

