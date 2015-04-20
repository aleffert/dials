//
//  DLSLiveDial.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/15/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSEditorDescription;

@interface DLSLiveDial : NSObject <NSCoding>

@property (strong, nonatomic, nonnull) id <DLSEditorDescription> editor;
@property (strong, nonatomic, nullable) id <NSCoding> value;

@property (copy, nonatomic, nonnull) NSString* displayName;
@property (copy, nonatomic, nonnull) NSString* group;
@property (copy, nonatomic, nonnull) NSString* uuid;

@property (assign, nonatomic) BOOL canSave;

@property (copy, nonatomic, nullable) NSString* file;
@property (assign, nonatomic) size_t line;

@end