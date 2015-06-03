//
//  DLSControlPanelPlugin.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/13/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <Dials/DLSPlugin.h>

@class DLSPropertyWrapper;
@protocol DLSEditor;
@protocol DLSRemovable;

NS_ASSUME_NONNULL_BEGIN

/// Plugin that allows you to add controls like buttons and
/// sliders connected to variables in your code.
/// When used with a variable corresponding to a setter in a line of code, it can be used to
/// update the value in your code directly from the desktop interface just be clicking a button.
@interface DLSControlPanelPlugin : NSObject <DLSPlugin>

/// Will be nil if Dials isn't started
+(nullable instancetype)activePlugin;

/// Begins a named control group. All added controls will be grouped in a
/// pane under the given name.
/// Should be balanced by a call to -endGroup.
/// @param name Display name of the group.
- (void)beginGroupWithName:(NSString*)name;

/// End a named control group.
/// Should correspond to a call to beginGroupWithName:.
- (void)endGroup;

/// All controls added within actions will be grouped in a pane under the given name.
/// Block based variant of -beginGroupWithName: -endGroup pairing.
/// @param name Display name of the group.
/// @param actions Code that will be executed.
- (void)groupWithName:(NSString*)name actions:(void (^)(void))actions;

/// Adds a control. Typically you don't call this directly and instead use one of the convenient macros
/// or Swift based wrapper functions.
/// @param wrapper      Moves data in and out of the underlying store.
/// @param editor       The desktop side editor for the property.
/// @param label        The user facing name of the control.
/// @param canSave      Whether it is possible to save changes to this property directly back to your code.
/// @param file         The name of the file this control is declared in.
/// @param line         The line of code this control is declared on.
- (id <DLSRemovable>)addControlWithWrapper:(DLSPropertyWrapper*)wrapper
                                 editor:(id <DLSEditor>)editor
                                  label:(NSString*)label
                                canSave:(BOOL)canSave
                                   file:(nullable NSString*)file
                                   line:(size_t)line;

@end

@interface DLSReferenceControlBuilder : NSObject

/// This is not typically called explicitly. Instead, use the DLSControl convenience macro
- (id)initWithLabel:(NSString *)label
            canSave:(BOOL)canSave
              owner:(id)owner
               file:(NSString *)file
               line:(size_t)line;

@property (readonly, nonatomic) id <DLSRemovable>(^actionOf)(dispatch_block_t);
@property (readonly, nonatomic) id <DLSRemovable>(^wrapperOf)(DLSPropertyWrapper*, id <DLSEditor> editor);

@property (readonly, nonatomic) id <DLSRemovable>(^colorOf)(UIColor* __strong __nullable * __nonnull);
@property (readonly, nonatomic) id <DLSRemovable>(^edgeInsetsOf)(UIEdgeInsets* __nonnull);
@property (readonly, nonatomic) id <DLSRemovable>(^labelOf)(NSString* __strong __nullable * __nonnull);
@property (readonly, nonatomic) id <DLSRemovable>(^imageOf)(UIImage* __strong __nullable * __nonnull);
@property (readonly, nonatomic) id <DLSRemovable>(^pointOf)(CGPoint* __nonnull);
@property (readonly, nonatomic) id <DLSRemovable>(^sizeOf)(CGSize* __nonnull);
@property (readonly, nonatomic) id <DLSRemovable>(^rectOf)(CGRect* __nonnull);
@property (readonly, nonatomic) id <DLSRemovable>(^sliderOf)(CGFloat *  __nonnull, CGFloat min, CGFloat max);
@property (readonly, nonatomic) id <DLSRemovable>(^stepperOf)(CGFloat * __nonnull);
@property (readonly, nonatomic) id <DLSRemovable>(^textFieldOf)(NSString*__strong __nullable * __nonnull);
@property (readonly, nonatomic) id <DLSRemovable>(^toggleOf)(BOOL * __nonnull);

@end

@interface DLSKeyPathControlBuilder : NSObject

/// This is not typically called explicitly. Instead, use the DLSControlForKeyPath convenience macro.
- (id)initWithKeyPath:(NSString *)keyPath
            canSave:(BOOL)canSave
              owner:(id)owner
               file:(NSString *)file
               line:(size_t)line;


@property (readonly, nonatomic) id <DLSRemovable>(^asEditor)(id <DLSEditor> editor);
@property (readonly, nonatomic) id <DLSRemovable>(^asColor)(void);
@property (readonly, nonatomic) id <DLSRemovable>(^asEdgeInsets)(void);
@property (readonly, nonatomic) id <DLSRemovable>(^asLabel)(void);
@property (readonly, nonatomic) id <DLSRemovable>(^asImage)(void);
@property (readonly, nonatomic) id <DLSRemovable>(^asPoint)(void);
@property (readonly, nonatomic) id <DLSRemovable>(^asRect)(void);
@property (readonly, nonatomic) id <DLSRemovable>(^asSize)(void);
@property (readonly, nonatomic) id <DLSRemovable>(^asStepper)(void);
@property (readonly, nonatomic) id <DLSRemovable>(^asTextField)(void);
@property (readonly, nonatomic) id <DLSRemovable>(^asSlider)(CGFloat min, CGFloat max);
@property (readonly, nonatomic) id <DLSRemovable>(^asToggle)(void);

@end

#define DLSControlGroupWithName(name__, actions__) [[DLSControlPanelPlugin activePlugin] groupWithName:name__ actions:actions__]

/// Use this to start creating a control with the given label.
/// Then use the methods on DLSReferenceControlBuilder to define the editor for the control.
/// For example DLSControl("Name").colorOf(&someUIColor).
#define DLSControl(label) [[DLSReferenceControlBuilder alloc] initWithLabel:label canSave:true owner:self file:@"" __FILE__ line:__LINE__]

/// Use this to start creating a control with the given label based on a
/// key path of the enclosing object.
/// Then use the methods on DLSKeyPathControlBuilder to define the editor for the control.
/// For example DLSControl("backgroundColor").asColor()
#define DLSControlForKeyPath(keypath) [[DLSKeyPathControlBuilder alloc] initWithKeyPath:@"" #keypath canSave:true owner:self file:@"" __FILE__ line:__LINE__]

NS_ASSUME_NONNULL_END
