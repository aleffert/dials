//
//  DLSControlPanelMessages.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSControlPanelMessages.h"

#import "DLSConstants.h"

NSString* const DLSControlPanelPluginIdentifier = @"com.akivaleffert.dials.control-panel";
NSString* const DLSControlPanelPluginDefaultGroup = @"Top Level";

@implementation DLSControlPanelMessage

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

@implementation DLSControlPanelAddMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
        DLSDecodeObject(aDecoder, info);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    DLSEncodeObject(aCoder, info);
}

@end

@implementation DLSControlPanelRemoveMessage

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

@implementation DLSControlPanelChangeMessage

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