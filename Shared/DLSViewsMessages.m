//
//  DLSViewsMessages.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/2/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSViewsMessages.h"

#import "DLSConstants.h"
#import "DLSTransform3D.h"

NSString* const DLSViewsPluginIdentifier = @"com.akivaleffert.dials.view-adjust";

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
        DLSDecodeObject(aDecoder, backgroundColor);
        DLSDecodeObject(aDecoder, borderColor);
        DLSDecodeObject(aDecoder, contentValues);
        DLSDecodeObject(aDecoder, geometryValues);
        DLSDecodeObject(aDecoder, shadowColor);
        DLSDecodeTransform3D(aDecoder, transform3D);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, backgroundColor);
    DLSEncodeObject(aCoder, borderColor);
    DLSEncodeObject(aCoder, contentValues);
    DLSEncodeObject(aCoder, geometryValues);
    DLSEncodeObject(aCoder, shadowColor);
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
        DLSDecodeObject(aDecoder, className);
        DLSDecodeObject(aDecoder, label);
        DLSDecodeObject(aDecoder, renderingInfo);
        DLSDecodeObject(aDecoder, address);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, viewID);
    DLSEncodeObject(aCoder, superviewID);
    DLSEncodeObject(aCoder, children);
    DLSEncodeObject(aCoder, className);
    DLSEncodeObject(aCoder, label);
    DLSEncodeObject(aCoder, renderingInfo);
    DLSEncodeObject(aCoder, address);
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

@implementation DLSViewsFullHierarchyMessage

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

@implementation DLSViewsViewPropertiesMessage

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

@implementation DLSViewsSelectViewMessage

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

@implementation DLSViewsUpdatedViewsMessage

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

@implementation DLSViewsUpdatedContentsMessage

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

@implementation DLSViewsValueChangedMessage

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