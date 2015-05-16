//
//  DLSOwnedChannel.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSChannel : NSObject
- (id)initWithName:(NSString*)name;

@property (readonly, copy, nonatomic) NSString* name;

@end


NS_ASSUME_NONNULL_END