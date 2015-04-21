//
//  DLSViewAdjustMessages.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/2/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const __nonnull DLSViewAdjustPluginName;

@protocol DLSEditorDescription;

@interface DLSPropertyRecord : NSObject <NSCoding>

@property (copy, nonatomic, nonnull) NSString* name;
@property (strong, nonatomic, nonnull) id <DLSEditorDescription> editor;
@property (strong, nonatomic, nullable) id <NSCoding> value;

@end

@interface DLSViewHierarchyRecord : NSObject <NSCoding>
/// Unique id of the corresponding view
@property (copy, nonatomic, nonnull) NSString* viewID;
/// [NSString(uuid)]
@property (copy, nonatomic, nonnull) NSArray* children;
@property (copy, nonatomic, nonnull) NSString* displayName;
@property (copy, nonatomic, nonnull) NSString* className;

@end


@interface DLSViewRecord : NSObject <NSCoding>
/// Unique id of the corresponding view
@property (copy, nonatomic, nullable) NSString* viewID;
/// [DLSPropertyGroup]
@property (copy, nonatomic, nonnull) NSArray* propertyGroups;
@property (copy, nonatomic, nonnull) NSString* className;
/// [NSString(group) : [NSString(name) : NSCoding(value)]
@property (copy, nonatomic, nonnull) NSDictionary* values;

@end

@interface DLSChangeViewValueRecord : NSObject <NSCoding>

- (nonnull id)initWithViewID:(NSString* __nonnull)viewID name:(NSString* __nonnull)name group:(NSString* __nonnull)group value:(id <NSCoding> __nullable)value;

@property (copy, nonatomic, nonnull) NSString* viewID;
@property (copy, nonatomic, nonnull) NSString* name;
@property (copy, nonatomic, nonnull) NSString* group;
@property (strong, nonatomic, nullable) id <NSCoding> value;

@end

#pragma mark Sent by iOS
@interface DLSViewAdjustFullHierarchyMessage : NSObject <NSCoding>

/// [NSString(viewID) : DLSViewHierarchyRecord(view info)]
@property (copy, nonatomic, nonnull) NSDictionary* hierarchy;
/// NSString(record UUIDs)]
@property (copy, nonatomic, nonnull) NSArray* topLevel;

@end

@interface DLSViewAdjustViewPropertiesMessage : NSObject <NSCoding>

@property (strong, nonatomic, nonnull) DLSViewRecord* record;

@end

@interface DLSViewAdjustUpdatedViewsMessage : NSObject <NSCoding>

/// [DLSViewHierarchyRecord]
@property (copy, nonatomic, nonnull) NSArray* records;
/// NSString(record UUIDs)]
@property (copy, nonatomic, nonnull) NSArray* topLevel;

@end

#pragma mark Sent by Desktop
@interface DLSViewAdjustSelectViewMessage : NSObject <NSCoding>

- (nonnull id)initWithViewID:(NSString* __nullable)viewID;

@property (strong, nonatomic, nullable) NSString* viewID;

@end

@interface DLSViewAdjustValueChangedMessage : NSObject <NSCoding>

- (nonnull id)initWithRecord:(DLSChangeViewValueRecord* __nonnull)record;

@property (strong, nonatomic, nullable) DLSChangeViewValueRecord* record;

@end
