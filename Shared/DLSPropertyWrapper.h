//
//  DLSPropertyWrapper.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSPropertyWrapper<A> : NSObject

- (id)initWithGetter:(__nullable A (^)(void))getter setter:(void(^)(__nullable A))setter NS_DESIGNATED_INITIALIZER;
- (id)initWithKeyPath:(NSString*)keyPath object:(id)object;

@property (copy, nonatomic) __nullable A (^getter)(void);
@property (copy, nonatomic) void (^setter)(__nullable A);

@end

NS_ASSUME_NONNULL_END