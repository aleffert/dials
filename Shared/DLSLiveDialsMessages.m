//
//  DLSLiveDialsMessages.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSLiveDialsMessages.h"

#import "DLSConstants.h"

NSString* const DLSLiveDialsPluginName = @"com.akivaleffert.live-dials";
NSString* const DLSLiveDialsPluginDefaultGroup = @"Top Level";

@implementation DLSLiveDialsAddMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, dial);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, dial);
}

@end

@implementation DLSLiveDialsRemoveMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, uuid);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, uuid);
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
        DLSDecodeObject(aDecoder, uuid);
        DLSDecodeObject(aDecoder, value);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, uuid);
    DLSEncodeObject(aCoder, value);
}


@end