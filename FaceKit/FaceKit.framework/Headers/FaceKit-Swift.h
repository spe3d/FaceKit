// Generated by Apple Swift version 2.2 (swiftlang-703.0.18.1 clang-703.0.29)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if defined(__has_feature) && __has_feature(modules)
@import CloudKit;
@import ObjectiveC;
@import Foundation;
@import SceneKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"

@interface CKContainer (SWIFT_EXTENSION(FaceKit))
@end

@class SCNNode;
@class NSCoder;
@class FKSuit;
@class NSError;
@class FKMotion;
@class FKHair;
@class FKGlasses;
@class NSData;


/// An FKAvatarController class has a node of the avatar on a scene graph. You have to show the avatar, you need to add sceneNode in your scene. To modify style on the avatar, use methods of FKAvatarController can immediately to update on the sceneNode.
///
/// Save an Avatar
///
/// FaceKit provides to save an avatar to a file.
/// <code>FKAvatarController
/// </code> class support the <code>NSSecureCoding
/// </code> protocol.
/// Use the <code>NSKeyedArchiver
/// </code> class to serialize an avatar and all its contents, and the <code>NSKeyedUnarchiver
/// </code> class to load an archived avatar.
SWIFT_CLASS("_TtC7FaceKit18FKAvatarController")
@interface FKAvatarController : NSObject <NSSecureCoding, NSCoding>

/// The node of the avatar on the scene graph.
@property (nonatomic, readonly, strong) SCNNode * _Nonnull sceneNode;

/// The default camera shoots the avatar with full body.
@property (nonatomic, readonly, strong) SCNNode * _Nonnull defaultCameraNode;

/// Get focused on the avatar's head of the camera.
@property (nonatomic, readonly, strong) SCNNode * _Nonnull headCameraNode;

/// Returns an object initialized from data in a given unarchiver.
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;

/// Encodes the receiver using a given archiver.
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;

/// Returns the class supports secure coding.
+ (BOOL)supportsSecureCoding;

/// Changes suit at the avatar.
- (void)setSuit:(FKSuit * _Null_unspecified)suit completionHandler:(void (^ _Nonnull)(BOOL, NSError * _Nullable))completionHandler;

/// Changes motion at the avatar.
- (void)setMotion:(FKMotion * _Null_unspecified)animation completionHandler:(void (^ _Nonnull)(BOOL, NSError * _Nullable))completionHandler;

/// Changes hair at the avatar.
- (void)setHair:(FKHair * _Null_unspecified)hair completionHandler:(void (^ _Nonnull)(BOOL, NSError * _Nullable))completionHandler;

/// Changes glasses at the avatar.
- (void)setGlasses:(FKGlasses * _Nullable)glasses completionHandler:(void (^ _Nonnull)(BOOL, NSError * _Nullable))completionHandler;

/// Changes facial at the avatar. We have more basic facial, the respective weight into the array where you can make the avatar show different facials. The weight range is 0-1.
- (void)setFacial:(NSArray<NSNumber *> * _Nonnull)weights;
- (void)saveAndPlayVoice:(NSData * _Nonnull)wavFileData willPlayClosure:(void (^ _Nullable)(void))willPlayClosure completion:(void (^ _Nullable)(BOOL))completion;
- (void)playLastVoice:(void (^ _Nullable)(BOOL))completion;
@end



/// An FKAvatarManager object lets you create a scene node, including a avatar. An avatar manager object is usually your first interaction with the scene node.
SWIFT_CLASS("_TtC7FaceKit15FKAvatarManager")
@interface FKAvatarManager : NSObject

/// Returns the shared manager object.
+ (FKAvatarManager * _Nonnull)currentManager;

/// The recommended way to install FaceKit into your APP is to place a call to +startWithAPIKey: in your -application:didFinishLaunchingWithOptions: or -applicationDidFinishLaunching: method.
+ (void)startWithAPIKey:(NSString * _Nonnull)apiKey;
+ (void)startWithAPIKey:(NSString * _Nonnull)apiKey cloudKitContainerName:(NSString * _Nonnull)containerName;
- (void)syncAvatarDefaultPresetsWithRestart:(BOOL)restart completionHandler:(void (^ _Nullable)(BOOL, NSError * _Nullable))completionHandler;
@end

@class UIImage;

SWIFT_CLASS("_TtC7FaceKit8FKPreset")
@interface FKPreset : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull name;
@property (nonatomic, strong) UIImage * _Nonnull previewImage;
@end



/// An instance of the FKGlasses class implements a glasses on the avatar. You can use this class to wear glasses, such as those you might let your avatar in glesses.
SWIFT_CLASS("_TtC7FaceKit9FKGlasses")
@interface FKGlasses : FKPreset
@end



/// An instance of the FKHair class implements a hair on the avatar. You can use this class to hair design, such as those you might dress up your hair.
SWIFT_CLASS("_TtC7FaceKit6FKHair")
@interface FKHair : FKPreset
@end



/// An instance of the FKMotion class implements a motion on the avatar. You can use this class to motion, such as those you might let your avatar dancing.
SWIFT_CLASS("_TtC7FaceKit8FKMotion")
@interface FKMotion : FKPreset
@end



SWIFT_CLASS("_TtC7FaceKit6FKSuit")
@interface FKSuit : FKPreset
@end


@interface NSUserDefaults (SWIFT_EXTENSION(FaceKit))
@end


@interface SCNGeometry (SWIFT_EXTENSION(FaceKit))
@end


@interface SCNScene (SWIFT_EXTENSION(FaceKit))
@end

#pragma clang diagnostic pop
