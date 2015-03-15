//
//  NSObject+DLSDeallocAction.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/7/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSRemovable;

@interface NSObject (DLSDeallocAction)

- (id <DLSRemovable>)dls_performActionOnDealloc:(void(^)(void))action;

@end
