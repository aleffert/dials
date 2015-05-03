//
//  DLSNetworkRequestsMessages.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 5/2/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSNetworkRequestsMessages.h"

#import "DLSConstants.h"

NSString* const DLSNetworkRequestsPluginName = @"com.akivaleffert.dials.network";

@implementation DLSNetworkConnectionMessage
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, connectionID);
        DLSDecodeObject(aDecoder, timestamp);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, connectionID);
    DLSEncodeObject(aCoder, timestamp);
}

@end

@implementation DLSNetworkConnectionBeganMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
        DLSDecodeObject(aDecoder, request);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    DLSEncodeObject(aCoder, request);
}

@end

@implementation DLSNetworkConnectionFailedMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
        DLSDecodeObject(aDecoder, error);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    DLSEncodeObject(aCoder, connectionID);
    DLSEncodeObject(aCoder, error);
}

@end

@implementation DLSNetworkConnectionReceivedDataMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
        DLSDecodeObject(aDecoder, data);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    DLSEncodeObject(aCoder, data);
}

@end

@implementation DLSNetworkConnectionCompletedMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
        DLSDecodeObject(aDecoder, response);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    DLSEncodeObject(aCoder, response);
}

@end
