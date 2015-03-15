//
//  DLSLiveDial.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/15/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSTypeDescription;

@interface DLSLiveDial : NSObject <NSCoding>

@property (copy, nonatomic) NSString* group;
@property (strong, nonatomic) id <DLSTypeDescription> type;
@property (copy, nonatomic) NSString* uuid;
@property (strong, nonatomic) id value;

@end