//
//  DLSDescriptionGroup.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/19/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLSPropertyGroup : NSObject <NSCoding>

@property (copy, nonatomic, nonnull) NSString* label;
/// [DLSPropertyDescription]
@property (copy, nonatomic, nonnull) NSArray* properties;

@end