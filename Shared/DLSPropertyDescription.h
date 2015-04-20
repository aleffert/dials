//
//  DLSPropertyDescription.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSEditorDescription;

@interface DLSPropertyDescription : NSObject <NSCoding>

+ (nonnull DLSPropertyDescription*)propertyDescriptionWithName:(nonnull NSString*)name editor:(nonnull id <DLSEditorDescription>)editor;
+ (nonnull DLSPropertyDescription*)propertyDescriptionWithName:(nonnull NSString*)name editor:(nonnull id <DLSEditorDescription>)editor displayName:(nonnull NSString*)displayName;

@property (readonly, strong, nonatomic, nonnull) id <DLSEditorDescription> editorDescription;
/// Should be unique within a class and its parents
@property (readonly, copy, nonatomic, nonnull) NSString* name;
/// Can be anything. If nil, the "name" property will be used for display
@property (readonly, copy, nonatomic, nonnull) NSString* displayName;

@end

DLSPropertyDescription* __nonnull DLSProperty(NSString*__nonnull name, id <DLSEditorDescription> __nonnull description );