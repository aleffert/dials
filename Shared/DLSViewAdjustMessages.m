//
//  DLSViewAdjustMessages.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/2/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSViewAdjustMessages.h"

#import "DLSConstants.h"
#import "DLSTransform3D.h"

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

@implementation DLSViewRenderingRecord

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodePoint(aDecoder, anchorPoint);
        DLSDecodeObject(aDecoder, backgroundColor);
        DLSDecodeDouble(aDecoder, borderWidth);
        DLSDecodeObject(aDecoder, borderColor);
        DLSDecodeRect(aDecoder, bounds);
        DLSDecodeDouble(aDecoder, cornerRadius);
        DLSDecodeDouble(aDecoder, opacity);
        DLSDecodePoint(aDecoder, position);
        DLSDecodeTransform3D(aDecoder, transform3D);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodePoint(aCoder, anchorPoint);
    DLSEncodeObject(aCoder, backgroundColor);
    DLSEncodeDouble(aCoder, borderWidth);
    DLSEncodeObject(aCoder, borderColor);
    DLSEncodeRect(aCoder, bounds);
    DLSEncodeDouble(aCoder, cornerRadius);
    DLSEncodeDouble(aCoder, opacity);
    DLSEncodePoint(aCoder, position);
    DLSEncodeTransform3D(aCoder, transform3D);
}

@end

@implementation DLSViewHierarchyRecord

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, viewID);
        DLSDecodeObject(aDecoder, superviewID);
        DLSDecodeObject(aDecoder, children);
        DLSDecodeObject(aDecoder, displayName);
        DLSDecodeObject(aDecoder, className);
        DLSDecodeObject(aDecoder, renderingInfo);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, viewID);
    DLSEncodeObject(aCoder, superviewID);
    DLSEncodeObject(aCoder, children);
    DLSEncodeObject(aCoder, displayName);
    DLSEncodeObject(aCoder, className);
    DLSEncodeObject(aCoder, renderingInfo);
}

@end

@implementation DLSViewRecord

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, viewID);
        DLSDecodeObject(aDecoder, propertyGroups);
        DLSDecodeObject(aDecoder, className);
        DLSDecodeObject(aDecoder, values);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, viewID);
    DLSEncodeObject(aCoder, propertyGroups);
    DLSEncodeObject(aCoder, className);
    DLSEncodeObject(aCoder, values);
}

@end

@implementation DLSChangeViewValueRecord

- (id)initWithViewID:(NSString*)viewID name:(NSString*)name group:(NSString*)group value:(id <NSCoding>)value {
    if(self != nil) {
        self.viewID = viewID;
        self.name = name;
        self.group = group;
        self.value = value;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, viewID);
        DLSDecodeObject(aDecoder, name);
        DLSDecodeObject(aDecoder, group);
        DLSDecodeObject(aDecoder, value);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, viewID);
    DLSEncodeObject(aCoder, name);
    DLSEncodeObject(aCoder, group);
    DLSEncodeObject(aCoder, value);
}

@end

@implementation DLSViewAdjustFullHierarchyMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, hierarchy);
        DLSDecodeObject(aDecoder, roots);
        DLSDecodeSize(aDecoder, screenSize);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, hierarchy);
    DLSEncodeObject(aCoder, roots);
    DLSEncodeSize(aCoder, screenSize);
}

@end

@implementation DLSViewAdjustViewPropertiesMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, record);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, record);
}

@end

@implementation DLSViewAdjustSelectViewMessage

- (id)initWithViewID:(NSString*)viewID {
    self = [super init];
    if(self != nil) {
        self.viewID = viewID;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, viewID);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, viewID);
}

@end

@implementation DLSViewAdjustUpdatedViewsMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, records);
        DLSDecodeObject(aDecoder, roots);
        DLSDecodeSize(aDecoder, screenSize);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, records);
    DLSEncodeObject(aCoder, roots);
    DLSEncodeSize(aCoder, screenSize);
}

@end

@implementation DLSViewAdjustUpdatedContentsMessage

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self != nil) {
        DLSDecodeObject(aDecoder, contents);
        DLSDecodeObject(aDecoder, empties);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, contents);
    DLSEncodeObject(aCoder, empties);
}

@end

@implementation DLSViewAdjustValueChangedMessage

- (id)initWithRecord:(DLSChangeViewValueRecord*)record {
    self = [super init];
    if(self != nil) {
        self.record = record;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, record);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, record);
}

@end