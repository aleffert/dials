//
//  DLSOwnedChannel.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSChannel <NSObject, NSCoding>

@property (readonly, copy, nonatomic) NSString* name;

@end

@interface DLSOwnedChannel : NSObject <DLSChannel>

- (id)initWithOwner:(NSString *)owner name:(NSString *)name;

@property (readonly, copy, nonatomic) NSString* name;
@property (readonly, copy, nonatomic) NSString* owner;

@end
