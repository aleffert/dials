//
//  DLSViewAdjustMessages.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/2/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const DLSViewAdjustPluginName;

@protocol DLSEditorDescription;

@interface DLSPropertyRecord : NSObject <NSCoding>

@property (copy, nonatomic) NSString* name;
@property (strong, nonatomic) id <DLSEditorDescription> editor;
@property (strong, nonatomic) id <NSCoding> value;

@end

@interface DLSPropertyGroup : NSObject <NSCoding>

/// Array of DLSPropertyRecord
@property (copy, nonatomic) NSString* name;
@property (strong, nonatomic) NSArray* items;

@end

@interface DLSViewHierarchyRecord : NSObject <NSCoding>
/// Unique id of the corresponding view
@property (copy, nonatomic) NSString* uuid;
/// Array of UUIDs
@property (copy, nonatomic) NSArray* children;
@property (copy, nonatomic) NSString* displayName;
@property (copy, nonatomic) NSString* className;

@end


@interface DLSViewRecord : NSObject <NSCoding>
/// Unique id of the corresponding view
@property (copy, nonatomic) NSString* uuid;
/// Array of DLSPropertyGroup*
@property (copy, nonatomic) NSArray* propertyGroups;
@property (copy, nonatomic) NSString* className;
/// Property name -> NSCoding*
@property (copy, nonatomic) NSDictionary* values;

@end


#pragma mark Sent by Desktop
@interface DLSViewAdjustRequestHierarchyMessage : NSObject <NSCoding>
@end

#pragma mark Sent by iOS
@interface DLSViewAdjustFullHierarchyMessage : NSObject <NSCoding>

/// Array of DLSViewHierarchyRecord
@property (copy, nonatomic) NSArray* hierarchy;

@end