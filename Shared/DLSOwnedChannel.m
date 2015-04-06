//
//  DLSOwnedChannel.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSOwnedChannel.h"

#import "DLSConstants.h"

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
        DLSDecodeObject(aDecoder, name);
        DLSDecodeObject(aDecoder, owner);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, name);
    DLSEncodeObject(aCoder, owner);
}

- (NSUInteger)hash {
    return [self.name hash] ^ [self.owner hash];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[DLSOwnedChannel class]] && [[object name] isEqual:self.name] && [[object owner] isEqualToString:[self owner]];
}

@end
