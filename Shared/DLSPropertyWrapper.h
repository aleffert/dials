//
//  DLSPropertyWrapper.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSPropertyWrapper : NSObject

- (id)initWithGetter:(__nullable id (^)(void))getter setter:(void(^)(__nullable id))setter NS_DESIGNATED_INITIALIZER;
- (id)initWithKeyPath:(NSString*)keyPath object:(id)object;

@property (copy, nonatomic) __nullable id (^getter)(void);
@property (copy, nonatomic) void (^setter)(__nullable id);

@end

NS_ASSUME_NONNULL_END