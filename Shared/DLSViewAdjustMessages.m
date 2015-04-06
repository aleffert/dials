//
//  DLSViewAdjustMessages.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/2/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSViewAdjustMessages.h"

#import "DLSConstants.h"

NSString* const DLSViewAdjustPluginName = @"com.akivaleffert.view-adjust";

@implementation DLSPropertyRecord

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, name);
        DLSDecodeObject(aDecoder, editor);
        DLSDecodeObject(aDecoder, value);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, name);
    DLSEncodeObject(aCoder, editor);
    DLSEncodeObject(aCoder, value);
}

@end

@implementation DLSPropertyGroup

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, name);
        DLSDecodeObject(aDecoder, items);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, name);
    DLSEncodeObject(aCoder, items);
}

@end

@implementation DLSViewHierarchyRecord

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, uuid);
        DLSDecodeObject(aDecoder, children);
        DLSDecodeObject(aDecoder, displayName);
        DLSDecodeObject(aDecoder, className);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSDecodeObject(aCoder, uuid);
    DLSDecodeObject(aCoder, children);
    DLSDecodeObject(aCoder, displayName);
    DLSDecodeObject(aCoder, className);
}

@end

@implementation DLSViewRecord

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, uuid);
        DLSDecodeObject(aDecoder, propertyGroups);
        DLSDecodeObject(aDecoder, className);
        DLSDecodeObject(aDecoder, values);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSDecodeObject(aCoder, uuid);
    DLSDecodeObject(aCoder, propertyGroups);
    DLSDecodeObject(aCoder, className);
    DLSDecodeObject(aCoder, values);
}

@end

@implementation DLSViewAdjustFullHierarchyMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, hierarchy);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, hierarchy);
}

@end

@implementation DLSViewAdjustRequestHierarchyMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    // no properties
    return [super init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // no properties
}

@end