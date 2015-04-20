//
//  DLSPropertyWrapper.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLSPropertyWrapper : NSObject

- (nonnull id)initWithGetter:(__nullable id (^__nonnull)(void))getter setter:(void(^__nonnull)(__nullable id))setter NS_DESIGNATED_INITIALIZER;

@property (copy, nonatomic, nonnull) __nullable id (^getter)(void);
@property (copy, nonatomic, nonnull) void (^setter)(__nullable id);

@end