//
//  DLSLiveDialsPlugin.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/13/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <Dials/DLSPlugin.h>

@class DLSPropertyWrapper;
@protocol DLSEditorDescription;
@protocol DLSRemovable;

NS_ASSUME_NONNULL_BEGIN

/// Plugin that allows you to add controls like buttons and
/// sliders connected to variables in your code.
/// When used with a variable corresponding to a setter in a line of code, it can be used to
/// update the value in your code directly from the desktop interface just be clicking a button.
@interface DLSLiveDialsPlugin : NSObject <DLSPlugin>

/// Will be nil if Dials isn't started
+(nullable instancetype)activePlugin;

/// Begins a named dial group. All added dials be grouped in a pane under the given name.
/// Should be balanced by a call to -endGroup.
/// @param name Display name of the group.
- (void)beginGroupWithName:(NSString*)name;

/// End a named dial group.
/// Should correspond to a call to beginGroupWithName:.
- (void)endGroup;

/// All dials added within actions will be grouped in a pane under the given name.
/// Block based variant of -beginGroupWithName: -endGroup pairing.
/// @param name Display name of the group.
/// @param actions Code that will be executed.
- (void)groupWithName:(NSString*)name actions:(void (^)(void))actions;

/// Adds a dial. Typically you don't call this directly and instead use one of the convenient macros
/// or Swift based wrapper functions.
/// @param wrapper      Moves data in and out of the underlying store.
/// @param editor       The desktop side editor for the property.
/// @param label        The user facing name of the dial.
/// @param canSave      Whether it is possible to save changes to this property directly back to your code.
/// @param file         The name of the file this dial is declared in.
/// @param line         The line of code this dial is declared on.
- (id <DLSRemovable>)addDialWithWrapper:(DLSPropertyWrapper*)wrapper
                                 editor:(id <DLSEditorDescription>)editor
                                  label:(NSString*)label
                                canSave:(BOOL)canSave
                                   file:(nullable NSString*)file
                                   line:(size_t)line;

@end

@interface DLSReferencePredial : NSObject

/// This is not typically called explicitly. Instead, use the DLSControl convenience macro
- (id)initWithLabel:(NSString *)label
            canSave:(BOOL)canSave
              owner:(id)owner
               file:(NSString *)file
               line:(size_t)line;

@property (readonly, nonatomic) id <DLSRemovable>(^actionOf)(dispatch_block_t);
@property (readonly, nonatomic) id <DLSRemovable>(^wrapperOf)(DLSPropertyWrapper*, id <DLSEditorDescription> editor);

@property (readonly, nonatomic) id <DLSRemovable>(^colorOf)(UIColor* __strong __nullable * __nonnull);
@property (readonly, nonatomic) id <DLSRemovable>(^labelOf)(NSString* __strong __nullable * __nonnull);
@property (readonly, nonatomic) id <DLSRemovable>(^sliderOf)(CGFloat *  __nonnull, CGFloat min, CGFloat max);
@property (readonly, nonatomic) id <DLSRemovable>(^stepperOf)(CGFloat * __nonnull);
@property (readonly, nonatomic) id <DLSRemovable>(^textFieldOf)(NSString*__strong __nullable * __nonnull);
@property (readonly, nonatomic) id <DLSRemovable>(^toggleOf)(BOOL * __nonnull);

@end

@interface DLSKeyPathPredial : NSObject

/// This is not typically called explicitly. Instead, use the DLSControl convenience macro
- (id)initWithKeyPath:(NSString *)keyPath
            canSave:(BOOL)canSave
              owner:(id)owner
               file:(NSString *)file
               line:(size_t)line;


@property (readonly, nonatomic) id <DLSRemovable>(^asEditor)(id <DLSEditorDescription> editor);
@property (readonly, nonatomic) id <DLSRemovable>(^asColor)(void);
@property (readonly, nonatomic) id <DLSRemovable>(^asLabel)(void);
@property (readonly, nonatomic) id <DLSRemovable>(^asTextField)(void);
@property (readonly, nonatomic) id <DLSRemovable>(^asSlider)(CGFloat min, CGFloat max);
@property (readonly, nonatomic) id <DLSRemovable>(^asToggle)(void);

@end

#define DLSControl(label) [[DLSReferencePredial alloc] initWithLabel:label canSave:true owner:self file:@"" __FILE__ line:__LINE__]
#define DLSControlForKeyPath(keypath) [[DLSKeyPathPredial alloc] initWithKeyPath:@"" #keypath canSave:true owner:self file:@"" __FILE__ line:__LINE__]

NS_ASSUME_NONNULL_END
