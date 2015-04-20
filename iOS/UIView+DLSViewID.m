//
//  UIView+DLSViewID.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 4/18/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "UIView+DLSViewID.h"

#import <objc/runtime.h>

static NSString* DLSViewIDKey = @"DLSViewIDKey";

@implementation UIView (DLSViewID)

- (NSString*)dls_viewID {
    NSString* viewID = objc_getAssociatedObject(self, &DLSViewIDKey);
    if(viewID == nil) {
        viewID = [NSUUID UUID].UUIDString;
        objc_setAssociatedObject(self, &DLSViewIDKey, viewID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return viewID;
}

@end
