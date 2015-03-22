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
        self.displayName = [aDecoder decodeObjectForKey:@"displayName"];
        self.editor = [aDecoder decodeObjectForKey:@"editor"];
        self.group = [aDecoder decodeObjectForKey:@"group"];
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
        
        self.file = [aDecoder decodeObjectForKey:@"file"];
        self.line = [aDecoder decodeIntegerForKey:@"line"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.group forKey:@"group"];
    [aCoder encodeObject:self.editor forKey:@"editor"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.value forKey:@"value"];
    [aCoder encodeObject:self.displayName forKey:@"displayName"];
    
    [aCoder encodeObject:self.file forKey:@"file"];
    [aCoder encodeInteger:self.line forKey:@"line"];
}

@end
