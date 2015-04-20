//
//  DLSOwnedChannel.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLSChannel : NSObject
- (id __nonnull)initWithName:(NSString * __nonnull)name;

@property (readonly, copy, nonatomic, nonnull) NSString* name;

@end
