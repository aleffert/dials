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

@interface DLSLiveDialsPlugin : NSObject <DLSPlugin>

+(instancetype)sharedPlugin;

- (void)beginGroupWithName:(NSString*)name;
- (void)endGroup;

- (id <DLSRemovable>)addDialWithWrapper:(DLSPropertyWrapper*)wrapper value:(id)value editor:(id <DLSEditorDescription>)editor displayName:(NSString*)displayName canSave:(BOOL)canSave file:(NSString*)file line:(size_t)line;

@end

@interface NSObject (DLSLiveDialsHelpers)

- (id <DLSRemovable>)dls_addDialForProperty:(NSString*)property editor:(id <DLSEditorDescription>)editor file:(char*)file line:(size_t)line;
- (id <DLSRemovable>)dls_addDialForAction:(void(^)(void))action name:(NSString*)name file:(char*)file line:(size_t)line;
- (id <DLSRemovable>)dls_addDialForGetter:(id(^)(void))getter setter:(void(^)(id))setter name:(NSString*)displayName editor:(id<DLSEditorDescription>)editor canSave:(BOOL)canSave file:(char *)file line:(size_t)line;

@end

#define DLSAddButtonAction(buttonName, action) [self dls_addDialForAction:action name:buttonName file:__FILE__ line:__LINE__]

#define DLSAddControl(displayName, getterAction, setterAction, editorDescription) \
    [self dls_addDialForGetter:getterAction setter:setterAction name:displayName editor:editorDescription canSave:YES file:__FILE__ line:__LINE__]
#define DLSAddToggleControl(label, symbol) \
    DLSAddControl(label, ^{ return @(symbol); }, ^(id updatedValue) { symbol = [updatedValue boolValue];}, [DLSToggleDescription editor])
#define DLSAddSliderControl(label, symbol, minValue, maxValue) \
    DLSAddControl(label, ^{ return @(symbol); }, ^(id updatedValue) { symbol = [updatedValue floatValue];}, [DLSSliderDescription sliderWithMin:minValue max:maxValue])

// MARK: Base
/// Creates a new live dial based on a given keypath and its type
#define DLSAddControlForKeyPath(keyPath, editorDescription) \
[self dls_addDialForProperty:@"" #keyPath editor:editorDescription file:__FILE__ line:__LINE__]

// Per Type Conveniences
#define DLSAddColorForKeyPath(keyPath) \
    DLSAddControlForKeyPath(keyPath, [DLSColorDescription editor])
#define DLSAddSliderForKeyPath(keyPath, minValue, maxValue) \
    DLSAddControlForKeyPath(keyPath, [DLSSliderDescription sliderWithMin:minValue max:maxValue])
#define DLSAddToggleForKeyPath(keyPath) \
    DLSAddControlForKeyPath(keyPath, [DLSToggleDescription editor])
