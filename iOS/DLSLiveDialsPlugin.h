//
//  DLSLiveDialsPlugin.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/13/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

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
/// @param value        The initial value.
/// @param editor       The desktop side editor for the property.
/// @param displayName  The user facing name of the dial.
/// @param canSave      Whether it is possible to save changes to this property directly back to your code.
/// @param file         The name of the file this dial is declared in.
/// @param line         The line of code this dial is declared on.
- (id <DLSRemovable>)addDialWithWrapper:(DLSPropertyWrapper*)wrapper
                                  value:(nullable id)value
                                 editor:(id <DLSEditorDescription>)editor
                            displayName:(NSString*)displayName
                                canSave:(BOOL)canSave
                                   file:(nullable NSString*)file
                                   line:(size_t)line;

@end

/// Assorted
@interface NSObject (DLSLiveDialsHelpers)

/// Creates a new dial corresponding to a property of the receiver.
/// The dial will automatically be removed when the receiver gets dealloced.
/// Typically you don't use this directly.
/// Instead you can use the various DLSAddControl macros.
/// @param property     The name of the property of the receiver this dial should represent
/// @param editor       The desktop side editor for the property
/// @param file         The name of the file this dial is declared in
/// @param line         The line of code this dial is declared on
- (id <DLSRemovable>)dls_addDialForProperty:(NSString*)property
                                     editor:(id <DLSEditorDescription>)editor
                                       file:(char*)file
                                       line:(size_t)line;

/// Creates a new dial corresponding to a button. Typically you don't use this directly.
/// Instead you can use the DLSAddButtonAction convenience macro.
/// The dial will automatically be removed when the receiver gets dealloced.
/// @param action       The action to be triggered when the button is clicked.
/// @param file         The name of the file this dial is declared in.
/// @param line         The line of code this dial is declared on.
- (id <DLSRemovable>)dls_addDialForAction:(void(^)(void))action
                                     name:(NSString*)name
                                     file:(char*)file
                                     line:(size_t)line;
/// Creates a new dial corresponding with an arbitrary accessor.
/// Typically you don't use this directly.
/// Instead you can use the DLSAddButtonAction convenience macro.
/// The dial will automatically be removed when the receiver gets dealloced.
/// @param file         The name of the file this dial is declared in.
/// @param line         The line of code this dial is declared on.
- (id <DLSRemovable>)dls_addDialForGetter:(id(^)(void))getter
                                   setter:(void(^)(id))setter
                                     name:(NSString*)displayName
                                   editor:(id<DLSEditorDescription>)editor
                                  canSave:(BOOL)canSave
                                     file:(char *)file
                                     line:(size_t)line;

@end

#pragma mark Variable based controls

/// @param buttonName The text of the button's label
/// @param action The actiont to execute when the button is clicked
#define DLSAddButtonAction(buttonName, action) [self dls_addDialForAction:action name:buttonName file:__FILE__ line:__LINE__]

/// @param displayName          The text of the button's label
/// @param getterAction         The action to execute to get a value for the control
/// @param setterAction         The action to execute to set a value from the control
/// @param editorDescription    The desktop side editor for the property
#define DLSAddControl(displayName, getterAction, setterAction, editorDescription) \
    [self dls_addDialForGetter:getterAction setter:setterAction name:displayName editor:editorDescription canSave:YES file:__FILE__ line:__LINE__]

/// @param label                The label text on the slider
/// @param symbol               The variable this slider corresponds to
/// @param minValue             The minimum value of the slider
/// @param maxValue             The maximum value of the slider
#define DLSAddSliderControl(label, symbol, minValue, maxValue) \
DLSAddControl(label, ^{ return @(symbol); }, ^(id updatedValue) { symbol = [updatedValue floatValue];}, [DLSSliderDescription sliderWithMin:minValue max:maxValue])

/// @param displayName          The text of the button's label
/// @param getterAction         The action to execute to get a value for the control
/// @param setterAction         The action to execute to set a value from the control
/// @param editorDescription    The desktop side editor for the property
#define DLSAddToggleControl(label, symbol) \
    DLSAddControl(label, ^{ return @(symbol); }, ^(id updatedValue) { symbol = [updatedValue boolValue];}, [DLSToggleDescription editor])

#pragma mark Key Path based controls

/// Creates a new live dial based for an arbitrary type
/// @param keyPath              The keypath of the enclosing object this corresponds to
/// @param editorDescription    The desktop side editor for the property
#define DLSAddControlForKeyPath(keyPath, editorDescription) \
[self dls_addDialForProperty:@"" #keyPath editor:editorDescription file:__FILE__ line:__LINE__]

// Per Type Conveniences

/// Creates a new live dial for a color
/// @param keyPath              The keypath of the enclosing object this corresponds to
#define DLSAddColorForKeyPath(keyPath) \
    DLSAddControlForKeyPath(keyPath, [DLSColorDescription editor])

/// Creates a new live dial for a slider
/// @param keyPath              The keypath of the enclosing object this corresponds to
#define DLSAddSliderForKeyPath(keyPath, minValue, maxValue) \
    DLSAddControlForKeyPath(keyPath, [DLSSliderDescription sliderWithMin:minValue max:maxValue])

/// Creates a new live dial for a slider
/// @param keyPath              The keypath of the enclosing object this corresponds to
#define DLSAddToggleForKeyPath(keyPath) \
    DLSAddControlForKeyPath(keyPath, [DLSToggleDescription editor])

NS_ASSUME_NONNULL_END