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

@protocol DLSTypeDescription;

@interface DLSLiveDialsPlugin : NSObject <DLSPlugin>

+(instancetype)sharedPlugin;

- (void)beginGroupWithName:(NSString*)name;
- (void)endGroup;

- (id <DLSRemovable>)addDialWithWrapper:(DLSPropertyWrapper*)wrapper value:(id)value type:(id <DLSTypeDescription>)type file:(char*)file line:(size_t)line;

@end

@interface NSObject (DLSLiveDialsHelpers)

- (id <DLSRemovable>)dls_addDialForProperty:(NSString*)property type:(id <DLSTypeDescription>)type file:(char*)file line:(size_t)line;
- (id <DLSRemovable>)dls_addDialForAction:(void(^)(void))action file:(char*)file line:(size_t)line;

@end

#define DLSAddButtonAction(action) [self dls_addDialForAction:action file:__FILE__ line:__LINE__]

#define DLSAddControl(propertyName, typeDescription) [self addDialForProperty:propertyName type:typeDescription file:__FILE__ line:__LINE__]
#define DLSAddSlider(propertyName, minValue, maxValue, isContinuous) DLSAddControler(propertyName, [DLSSliderDescription sliderWithMin:minValue max:maxValue continuous:isContinuous])
#define DLSAddToggle(propertyName) DLSAddControler(propertyName, [DLSToggleDescription toggle])