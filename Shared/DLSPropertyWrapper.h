//
//  DLSPropertyWrapper.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLSPropertyWrapper : NSObject

- (__nonnull id)initWithGetter:(__nullable id (^__nonnull)(void))getter setter:(void(^__nonnull)(__nullable id))setter NS_DESIGNATED_INITIALIZER;

@property (copy, nonatomic) __nullable id (^__nonnull getter)(void);
@property (copy, nonatomic) void (^__nonnull setter)(__nullable id);

@end