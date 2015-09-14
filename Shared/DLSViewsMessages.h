//
//  DLSViewsMessages.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/2/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "DLSConstants.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString* const DLSViewsPluginIdentifier;

@class DLSPropertyGroup;

@protocol DLSEditor;

@interface DLSPropertyRecord : NSObject <NSCoding>

@property (copy, nonatomic) NSString* name;
@property (strong, nonatomic) id <DLSEditor> editor;
@property (strong, nonatomic, nullable) id <NSCoding> value;

@end

@interface DLSViewRenderingRecord : NSObject <NSCoding>

// See corresponding CALayer properties

@property (strong, nonatomic, nullable) DLSColor* backgroundColor;
@property (strong, nonatomic, nullable) DLSColor* borderColor;
@property (strong, nonatomic, nullable) DLSColor* shadowColor;
@property (assign, nonatomic) CATransform3D transform3D;
@property (copy, nonatomic) NSDictionary<NSString*,id>* geometryValues;
@property (copy, nonatomic) NSDictionary<NSString*,id>* contentValues;

@end

@interface DLSViewHierarchyRecord : NSObject <NSCoding>
/// Unique id of the corresponding view
@property (copy, nonatomic) NSString* viewID;
@property (copy, nonatomic, nullable) NSString* superviewID;
@property (copy, nonatomic) NSArray<NSString*>* children;
@property (copy, nonatomic) NSString* label;
@property (copy, nonatomic) NSString* className;
@property (copy, nonatomic) NSString* address;

@property (assign, nonatomic) BOOL selectable;

@property (strong, nonatomic) DLSViewRenderingRecord* renderingInfo;

@end


@interface DLSViewRecord : NSObject <NSCoding>
/// Unique id of the corresponding view
@property (copy, nonatomic, nullable) NSString* viewID;
@property (copy, nonatomic) NSArray<DLSPropertyGroup*>* propertyGroups;
@property (copy, nonatomic) NSString* className;
@property (copy, nonatomic) NSDictionary<NSString*, NSDictionary<NSString*, id <NSCoding>>*>* values;

@end

@interface DLSChangeViewValueRecord : NSObject <NSCoding>

- (id)initWithViewID:(NSString*)viewID name:(NSString*)name group:(NSString*)group value:(id <NSCoding> __nullable)value;

@property (copy, nonatomic) NSString* viewID;
@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* group;
@property (strong, nonatomic, nullable) id <NSCoding> value;

@end

#pragma mark Sent by iOS
@interface DLSViewsFullHierarchyMessage : NSObject <NSCoding>

/// [NSString(viewID) : DLSViewHierarchyRecord(view info)]
@property (copy, nonatomic) NSDictionary<NSString*, DLSViewHierarchyRecord*>* hierarchy;
/// NSString(record UUIDs)]
@property (copy, nonatomic) NSArray<NSString*>* roots;
@property (assign, nonatomic) CGSize screenSize;

@end

@interface DLSViewsViewPropertiesMessage : NSObject <NSCoding>

@property (strong, nonatomic) DLSViewRecord* record;

@end

@interface DLSViewsUpdatedViewsMessage : NSObject <NSCoding>

/// [DLSViewHierarchyRecord]
@property (copy, nonatomic) NSArray<DLSViewHierarchyRecord*>* records;
/// NSString(record UUIDs)]
@property (copy, nonatomic) NSArray<NSString*>* roots;
@property (assign, nonatomic) CGSize screenSize;

@end


@interface DLSViewsUpdatedContentsMessage : NSObject <NSCoding>

/// [NSString:NSData(UIImage)]
@property (copy, nonatomic) NSDictionary<NSString*, NSData*>* contents;
@property (copy, nonatomic) NSArray<NSString*>* empties;

@end

#pragma mark Sent by Desktop
@interface DLSViewsSelectViewMessage : NSObject <NSCoding>

- (id)initWithViewID:(NSString* __nullable)viewID;

@property (strong, nonatomic, nullable) NSString* viewID;

@end

@interface DLSViewsValueChangedMessage : NSObject <NSCoding>

- (id)initWithRecord:(DLSChangeViewValueRecord*)record;

@property (strong, nonatomic, nullable) DLSChangeViewValueRecord* record;

@end

@interface DLSViewsInsetViewMessage : NSObject <NSCoding>

/// @param insets Dictionary (top, left, bottom, right) representing the edge insets
- (id)initWithViewID:(NSString*)viewID insets:(NSDictionary*)insets;

@property (copy, nonatomic) NSString* viewID;
@property (copy, nonatomic) NSDictionary<NSString*, NSNumber*>* insets;

@end

NS_ASSUME_NONNULL_END
