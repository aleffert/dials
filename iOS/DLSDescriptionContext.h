//
//  DLSDescriptionContext.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DLSPropertyDescription.h"
#import "UIView+DLSDescribable.h"

NS_ASSUME_NONNULL_BEGIN

@class DLSPropertyDescription;
@class DLSValueMapper;
@class DLSValueExchanger;
@protocol DLSEditor;

DLSPropertyDescription* DLSProperty(NSString* name, id <DLSEditor> editor);

@protocol DLSDescriptionContext <NSObject>

/// Call this to add a new group for a view like "Layer", "Scroll View"
/// @param name The user facing name of the group.
/// Should be unique for a given object hierarchy.
/// @param properties An array of DLSPropertyDescription.
/// These should be constructed using the DLSProperty function
- (void)addGroupWithName:(NSString*)name properties:(NSArray<DLSPropertyDescription*>*)properties;

@end

/// Extensions to control how this property is converted between representations.
/// In particular, used for things that don't implement NSCoding like CGColorRef
/// and NSValues wrapped around CGRects. See UIView+DLSDescribable for examples
@interface DLSPropertyDescription (DLSValueExtensions)

/// Way to set this property onto a particular object
@property (readonly, strong, nonatomic) DLSValueExchanger* exchanger;
/// Compose the current exchanger with this mapper to set a new exchanger.
@property (readonly, nonatomic) DLSPropertyDescription* (^composeMapper)(DLSValueMapper* mapper);
/// Set the exchanger.
@property (readonly, nonatomic) DLSPropertyDescription* (^setExchanger)(DLSValueExchanger* exchanger);

@end

NS_ASSUME_NONNULL_END