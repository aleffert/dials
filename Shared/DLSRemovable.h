//
//  DLSRemovable.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSRemovable <NSObject>

- (void)remove;

@end

@interface DLSBlockRemovable : NSObject <DLSRemovable>

- (id)initWithRemoveAction:(void(^)(void))action;

@end