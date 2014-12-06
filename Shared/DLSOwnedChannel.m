//
//  DLSOwnedChannel.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSOwnedChannel.h"

static NSString* const DLSOwnedChannelNameKey = @"DLSOwnedChannelNameKey";
static NSString* const DLSOwnedChannelOwnerKey = @"DLSOwnedChannelOwnerKey";

@interface DLSOwnedChannel ()

@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* owner;

@end

@implementation DLSOwnedChannel

- (id)initWithOwner:(NSString *)owner name:(NSString *)name {
    self = [super init];
    if(self != nil) {
        self.owner = owner;
        self.name = name;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        self.name = [aDecoder decodeObjectForKey:DLSOwnedChannelNameKey];
        self.owner = [aDecoder decodeObjectForKey:DLSOwnedChannelOwnerKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:DLSOwnedChannelNameKey];
    [aCoder encodeObject:self.name forKey:DLSOwnedChannelOwnerKey];
}

@end
