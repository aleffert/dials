//
//  DLSOwnedChannel.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSChannel.h"

#import "DLSConstants.h"

@interface DLSChannel ()

@property (copy, nonatomic) NSString* name;

@end

@implementation DLSChannel

- (id)initWithName:(NSString *)name {
    self = [super init];
    if(self != nil) {
        self.name = name;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, name);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, name);
}

- (NSUInteger)hash {
    return [self.name hash];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[DLSChannel class]] && [[object name] isEqual:self.name];
}

@end
