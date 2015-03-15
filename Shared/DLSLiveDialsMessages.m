//
//  DLSLiveDialsMessages.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSLiveDialsMessages.h"

@implementation DLSLiveDialsAddMessage

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.dial forKey:@"dial"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        self.dial = [aDecoder decodeObjectForKey:@"dial"];
    }
    return self;
}

@end

@implementation DLSLiveDialsRemoveMessage

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
    }
    return self;
}


@end

@implementation DLSLiveDialsChangeMessage

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.value forKey:@"value"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
    }
    return self;
}

@end