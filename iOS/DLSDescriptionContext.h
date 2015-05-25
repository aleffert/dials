//
//  DLSDescriptionContext.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DLSPropertyDescription.h"

NS_ASSUME_NONNULL_BEGIN

@class DLSPropertyDescription;
@class DLSValueMapper;
@class DLSValueExchanger;
@protocol DLSEditor;

DLSPropertyDescription* DLSProperty(NSString* name, id <DLSEditor> editor);

@protocol DLSDescriptionContext <NSObject>

// [DLSPropertyDescription]. Should be constructed using the DLSProperty functions
- (void)addGroupWithName:(NSString*)name properties:(NSArray*)properties;

@end

@interface DLSDescriptionAccumulator : NSObject <DLSDescriptionContext>

/// Array of DLSDescriptionGroup
@property (readonly, nonatomic) NSArray* groups;

@end

/// Extensions to controls how this property is converted between representations.
/// In particular, used for things that don't implement NSCoding like CGColorRef
/// and NSValue
@interface DLSPropertyDescription (DLSValueExtensions)

/// Way to set this property onto a particular object
@property (readonly, strong, nonatomic) DLSValueExchanger* exchanger;
/// Compose the current exchanger with this mapper to set a new exchanger.
@property (readonly, nonatomic) DLSPropertyDescription* (^composeMapper)(DLSValueMapper* mapper);
/// Set the exchanger.
@property (readonly, nonatomic) DLSPropertyDescription* (^setExchanger)(DLSValueExchanger* exchanger);

@end

NS_ASSUME_NONNULL_END