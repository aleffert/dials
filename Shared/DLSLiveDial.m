//
//  DLSLiveDial.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/15/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSLiveDial.h"

@implementation DLSLiveDial

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        self.group = [aDecoder decodeObjectForKey:@"group"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.group forKey:@"group"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.value forKey:@"value"];
}

@end
