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

@property (copy, nonatomic) NSString* displayName;
@property (strong, nonatomic) id <DLSEditorDescription> editor;
@property (copy, nonatomic) NSString* group;
@property (copy, nonatomic) NSString* uuid;
@property (strong, nonatomic) id <NSCoding> value;

@property (copy, nonatomic) NSString* file;
@property (assign, nonatomic) size_t line;

@end