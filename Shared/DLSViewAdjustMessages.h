//
//  DLSViewAdjustMessages.h
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

extern NSString* const __nonnull DLSViewAdjustPluginName;

@protocol DLSEditorDescription;

@interface DLSPropertyRecord : NSObject <NSCoding>

@property (copy, nonatomic) NSString* name;
@property (strong, nonatomic) id <DLSEditorDescription> editor;
@property (strong, nonatomic, nullable) id <NSCoding> value;

@end

@interface DLSViewRenderingRecord : NSObject <NSCoding>
// TODO: Add remaining layer properties

// See corresponding CALayer properties

@property (assign, nonatomic) CGPoint anchorPoint;
@property (strong, nonatomic, nullable) DLSColor* backgroundColor;
@property (assign, nonatomic) CGFloat borderWidth;
@property (strong, nonatomic, nullable) DLSColor* borderColor;
@property (assign, nonatomic) CGRect bounds;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) CGFloat opacity;
@property (assign, nonatomic) CGPoint position;
@property (assign, nonatomic) CATransform3D transform3D;

@end

@interface DLSViewHierarchyRecord : NSObject <NSCoding>
/// Unique id of the corresponding view
@property (copy, nonatomic) NSString* viewID;
@property (copy, nonatomic, nullable) NSString* superviewID;
/// [NSString(uuid)]
@property (copy, nonatomic) NSArray* children;
@property (copy, nonatomic) NSString* displayName;
@property (copy, nonatomic) NSString* className;
@property (copy, nonatomic) NSString* address;

@property (strong, nonatomic) DLSViewRenderingRecord* renderingInfo;

@end


@interface DLSViewRecord : NSObject <NSCoding>
/// Unique id of the corresponding view
@property (copy, nonatomic, nullable) NSString* viewID;
/// [DLSPropertyGroup]
@property (copy, nonatomic) NSArray* propertyGroups;
@property (copy, nonatomic) NSString* className;
/// [NSString(group) : [NSString(name) : NSCoding(value)]
@property (copy, nonatomic) NSDictionary* values;

@end

@interface DLSChangeViewValueRecord : NSObject <NSCoding>

- (id)initWithViewID:(NSString*)viewID name:(NSString*)name group:(NSString*)group value:(id <NSCoding> __nullable)value;

@property (copy, nonatomic) NSString* viewID;
@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* group;
@property (strong, nonatomic, nullable) id <NSCoding> value;

@end

#pragma mark Sent by iOS
@interface DLSViewAdjustFullHierarchyMessage : NSObject <NSCoding>

/// [NSString(viewID) : DLSViewHierarchyRecord(view info)]
@property (copy, nonatomic) NSDictionary* hierarchy;
/// NSString(record UUIDs)]
@property (copy, nonatomic) NSArray* roots;
@property (assign, nonatomic) CGSize screenSize;

@end

@interface DLSViewAdjustViewPropertiesMessage : NSObject <NSCoding>

@property (strong, nonatomic) DLSViewRecord* record;

@end

@interface DLSViewAdjustUpdatedViewsMessage : NSObject <NSCoding>

/// [DLSViewHierarchyRecord]
@property (copy, nonatomic) NSArray* records;
/// NSString(record UUIDs)]
@property (copy, nonatomic) NSArray* roots;
@property (assign, nonatomic) CGSize screenSize;

@end


@interface DLSViewAdjustUpdatedContentsMessage : NSObject <NSCoding>

/// [NSString:NSData(UIImage)]
@property (copy, nonatomic) NSDictionary* contents;
@property (copy, nonatomic) NSArray* empties;

@end

#pragma mark Sent by Desktop
@interface DLSViewAdjustSelectViewMessage : NSObject <NSCoding>

- (id)initWithViewID:(NSString* __nullable)viewID;

@property (strong, nonatomic, nullable) NSString* viewID;

@end

@interface DLSViewAdjustValueChangedMessage : NSObject <NSCoding>

- (id)initWithRecord:(DLSChangeViewValueRecord*)record;

@property (strong, nonatomic, nullable) DLSChangeViewValueRecord* record;

@end

NS_ASSUME_NONNULL_END
