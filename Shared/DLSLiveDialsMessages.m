//
//  DLSLiveDialsMessages.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSLiveDialsMessages.h"

#import "DLSConstants.h"

NSString* const DLSLiveDialsPluginName = @"com.akivaleffert.dials.live-dials";
NSString* const DLSLiveDialsPluginDefaultGroup = @"Top Level";

@implementation DLSLiveDialsMessage

- (id)initWithGroup:(NSString *)group {
    if(self != nil) {
        self.group = group;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, group);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, group);
}

@end

@implementation DLSLiveDialsAddMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
        DLSDecodeObject(aDecoder, dial);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    DLSEncodeObject(aCoder, dial);
}

@end

@implementation DLSLiveDialsRemoveMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
        DLSDecodeObject(aDecoder, uuid);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    DLSEncodeObject(aCoder, uuid);
}

@end

@implementation DLSLiveDialsChangeMessage

- (id)initWithUUID:(NSString*)uuid value:(id <NSCoding>)value group:(NSString *)group{
    self = [super initWithGroup:group];
    if(self != nil) {
        self.uuid = uuid;
        self.value = value;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
        DLSDecodeObject(aDecoder, uuid);
        DLSDecodeObject(aDecoder, value);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    DLSEncodeObject(aCoder, uuid);
    DLSEncodeObject(aCoder, value);
}


@end