//
//  NSLayoutConstraint+DLSUniqueness.m
//  Dials
//
//  Created by Akiva Leffert on 9/30/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import "NSLayoutConstraint+DLSUniqueness.h"

#import <objc/runtime.h>

@implementation NSLayoutConstraint (DLSUniqueness)

+ (NSMapTable<NSString*, NSLayoutConstraint*>*)dls_constraintTable {
    static NSMapTable<NSString*, NSLayoutConstraint*>* constraints;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        constraints = [NSMapTable weakToStrongObjectsMapTable];
    });
    return constraints;
}

- (NSString*)dls_constraintID {
    static NSString* constraintIDKey = @"";
    NSMapTable<NSString*, NSLayoutConstraint*>* constraints = [[self class] dls_constraintTable];
    NSString* result = objc_getAssociatedObject(self, &constraintIDKey);
    if(result == nil) {
        result = [NSUUID UUID].UUIDString;
        [constraints setObject:self forKey:result];
        objc_setAssociatedObject(self, &constraintIDKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

+ (nullable NSLayoutConstraint*)dls_constraintWithID:(NSString*)constraintID {
    return [[self dls_constraintTable] objectForKey:constraintID];
}

@end
