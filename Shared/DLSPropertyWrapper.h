//
//  DLSPropertyWrapper.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLSPropertyWrapper : NSObject

- (id)initWithGetter:(id (^)(void))getter setter:(void(^)(id))setter NS_DESIGNATED_INITIALIZER;

@property (copy, nonatomic) id (^getter)(void);
@property (copy, nonatomic) void (^setter)(id);

@end