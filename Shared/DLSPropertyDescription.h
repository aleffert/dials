//
//  DLSPropertyDescription.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSPropertyWrapper;

@protocol DLSEditor;

NS_ASSUME_NONNULL_BEGIN

@interface DLSPropertyDescription : NSObject <NSCoding>

+ (DLSPropertyDescription*)propertyDescriptionWithName:(NSString*)name editor:(id <DLSEditor>)editor;
+ (DLSPropertyDescription*)propertyDescriptionWithName:(NSString*)name editor:(id <DLSEditor>)editor label:(nullable NSString*)label;

@property (readonly, nonatomic) DLSPropertyDescription* (^setLabel)(NSString* label);
@property (readonly, nonatomic) DLSPropertyDescription* (^composeWrapper)(DLSPropertyWrapper* wrapper);

/// Editor to use for this property
@property (readonly, strong, nonatomic) id <DLSEditor> editor;

/// Should be unique within a class and its parents
@property (readonly, copy, nonatomic) NSString* name;

/// User facing label for this property.
/// If nil, the "name" property will be used for display
@property (readonly, copy, nonatomic) NSString* label;

@end

NS_ASSUME_NONNULL_END
