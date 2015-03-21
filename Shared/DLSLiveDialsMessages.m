//
//  DLSLiveDialsMessages.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSLiveDialsMessages.h"

NSString* const DLSLiveDialsPluginName = @"com.akivaleffert.live-dials";
NSString* const DLSLiveDialsPluginDefaultGroup = @"$$DEFAULT_GROUP$$";

@implementation DLSLiveDialsAddMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        self.dial = [aDecoder decodeObjectForKey:@"dial"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.dial forKey:@"dial"];
}

@end

@implementation DLSLiveDialsRemoveMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
}

@end

@implementation DLSLiveDialsChangeMessage

- (id)initWithUUID:(NSString*)uuid value:(id <NSCoding>)value {
    self = [super init];
    if(self != nil) {
        self.uuid = uuid;
        self.value = value;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.value forKey:@"value"];
}


@end