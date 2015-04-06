//
//  UIView+DLSViewAdjust.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 4/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "UIView+DLSViewAdjust.h"

#import <objc/runtime.h>

static NSString* const DLSViewUUIDKey = @"DLSViewUUIDKey";

@implementation UIView (DLSViewAdjust)

- (NSString*)dls_uuid {
    NSString* uuid = objc_getAssociatedObject(self, &DLSViewUUIDKey);
    if(uuid == nil) {
        uuid = [NSUUID UUID].UUIDString;
        objc_setAssociatedObject(self, &DLSViewUUIDKey, uuid, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return uuid;
}

@end
