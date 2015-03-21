//
//  DLSLiveDialsPlugin.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/13/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Dials/DLSPlugin.h>

@protocol DLSRemovable;

@interface DLSPropertyWrapper : NSObject

@property (copy, nonatomic) id (^getter)(void);
@property (copy, nonatomic) void (^setter)(id);

@end

@protocol DLSEditorDescription;

@interface DLSLiveDialsPlugin : NSObject <DLSPlugin>

+(instancetype)sharedPlugin;

- (void)beginGroupWithName:(NSString*)name;
- (void)endGroup;

- (id <DLSRemovable>)addDialWithWrapper:(DLSPropertyWrapper*)wrapper value:(id)value editor:(id <DLSEditorDescription>)editor displayName:(NSString*)displayName file:(char*)file line:(size_t)line;

@end

@interface NSObject (DLSLiveDialsHelpers)

- (id <DLSRemovable>)dls_addDialForProperty:(NSString*)property editor:(id <DLSEditorDescription>)type file:(char*)file line:(size_t)line;
- (id <DLSRemovable>)dls_addDialForAction:(void(^)(void))action name:(NSString*)name file:(char*)file line:(size_t)line;

@end

#define DLSAddButtonAction(buttonName, action) [self dls_addDialForAction:action name:buttonName file:__FILE__ line:__LINE__]

// MARK: Base
/// Creates a new live dial based on a given keypath and its type
#define DLSAddControl(keyPath, editorDescription) [self dls_addDialForProperty:@"" #keyPath editor:editorDescription file:__FILE__ line:__LINE__]

// Per Type Conveniences
#define DLSAddColor(keyPath) DLSAddControl(keyPath, [DLSColorDescription editor])
#define DLSAddSlider(keyPath, minValue, maxValue, isContinuous) DLSAddControl(keyPath, [DLSSliderDescription sliderWithMin:minValue max:maxValue continuous:isContinuous])
#define DLSAddToggle(keyPath) DLSAddControl(keyPath, [DLSToggleDescription editor])