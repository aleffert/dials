//
//  DLSConstraintDescription.m
//  Dials+SnapKit
//
//  Created by Akiva Leffert on 9/25/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import "DLSConstraintDescription.h"

#import "DLSConstants.h"

#if TARGET_OS_IPHONE
#import "DLSViewsPlugin+Internal.h"
#import <objc/runtime.h>

NSString* DLSPortableLayoutRelation(NSLayoutRelation relation) {
    switch(relation) {
        case NSLayoutRelationLessThanOrEqual: return @"<=";
        case NSLayoutRelationGreaterThanOrEqual: return @">=";
        case NSLayoutRelationEqual: return @"=";
    }
}

NSString* DLSPortableLayoutAttribute(NSLayoutAttribute attribute) {
    // Case because the system actually sends values outside of the core range!
    switch((NSInteger)attribute) {
        case NSLayoutAttributeLeft: return @"left";
        case NSLayoutAttributeRight: return @"right";
        case NSLayoutAttributeTop: return @"top";
        case NSLayoutAttributeBottom: return @"bottom";
        case NSLayoutAttributeLeading: return @"leading";
        case NSLayoutAttributeTrailing: return @"trailing";
        case NSLayoutAttributeWidth: return @"width";
        case NSLayoutAttributeHeight: return @"height";
        case NSLayoutAttributeCenterX: return @"centerX";
        case NSLayoutAttributeCenterY: return @"centerY";
        case NSLayoutAttributeBaseline: return @"baseline";
        case NSLayoutAttributeFirstBaseline: return @"firstBaseline";
        case NSLayoutAttributeLeftMargin: return @"leftMargin";
        case NSLayoutAttributeRightMargin: return @"rightMargin";
        case NSLayoutAttributeTopMargin: return @"topMargin";
        case NSLayoutAttributeBottomMargin: return @"bottomMargin";
        case NSLayoutAttributeLeadingMargin: return @"leadingMargin";
        case NSLayoutAttributeTrailingMargin: return @"trailingMargin";
        case NSLayoutAttributeCenterXWithinMargins: return @"centerXWithinMargins";
        case NSLayoutAttributeCenterYWithinMargins: return @"CenterYWithinMargins";
        case NSLayoutAttributeNotAnAttribute:
            return nil;
        case 32:
            // Not documented! Appears when autosizing is translated into constraints
            return @"leftInset";
        case 33:
            // Not documented! Appears when autosizing is translated into constraints
            return @"rightInset";
        default:
            NSLog(@"Unknown attribute %ld", (long)attribute);
            return @"???";
    }
}

@interface NSLayoutConstraint (DLSUniqueness)

@property (readonly, nonatomic) NSString* dls_constraintID;

@end

@implementation NSLayoutConstraint (DLSUniqueness)

- (NSString*)dls_constraintID {
    static NSString* constraintIDKey = @"";
    static NSMapTable<NSString*, NSLayoutConstraint*>* constraints;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        constraints = [NSMapTable weakToStrongObjectsMapTable];
    });
    
    NSString* result = objc_getAssociatedObject(self, &constraintIDKey);
    if(result == nil) {
        result = [NSUUID UUID].UUIDString;
        [constraints setObject:self forKey:result];
        objc_setAssociatedObject(self, &constraintIDKey, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

@end

#endif

@implementation DLSConstraintDescription

#if TARGET_OS_IPHONE
- (id)initWithView:(UIView*)view constraint:(NSLayoutConstraint*)constraint extras:(NSArray<DLSAuxiliaryConstraintInformation*>*)extras {
    self = [super init];
    if(self != nil) {
        id source = constraint.firstItem;
        id destination = constraint.secondItem;
        self.affectedViewID = [[DLSViewsPlugin activePlugin] viewIDForView:view];
        self.constraintID = constraint.dls_constraintID;
        self.sourceClass = [[source class] description];
        self.destinationClass = [[destination class] description];
        self.relation = DLSPortableLayoutRelation(constraint.relation);
        self.constant = constraint.constant;
        self.multiplier = constraint.multiplier;
        self.active = constraint.active;
        self.sourceAttribute = DLSPortableLayoutAttribute(constraint.firstAttribute);
        self.destinationAttribute = DLSPortableLayoutAttribute(constraint.secondAttribute);
        if([source isKindOfClass:[UIView class]]) {
            self.sourceViewID = [[DLSViewsPlugin activePlugin] viewIDForView:source];
        }
        if([destination isKindOfClass:[UIView class]]) {
            self.destinationViewID = [[DLSViewsPlugin activePlugin] viewIDForView:destination];
        }
    }
    return self;
}
#endif
    
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, affectedViewID);
        DLSDecodeObject(aDecoder, constraintID);
        DLSDecodeObject(aDecoder, relation);
        DLSDecodeObject(aDecoder, sourceClass);
        DLSDecodeObject(aDecoder, sourceViewID);
        DLSDecodeObject(aDecoder, sourceAttribute);
        DLSDecodeObject(aDecoder, destinationClass);
        DLSDecodeObject(aDecoder, destinationViewID);
        DLSDecodeObject(aDecoder, destinationAttribute);
        DLSDecodeDouble(aDecoder, constant);
        DLSDecodeDouble(aDecoder, multiplier);
        DLSDecodeDouble(aDecoder, priority);
        DLSDecodeBool(aDecoder, active);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, affectedViewID);
    DLSEncodeObject(aCoder, constraintID);
    DLSEncodeObject(aCoder, relation);
    DLSEncodeObject(aCoder, sourceClass);
    DLSEncodeObject(aCoder, sourceViewID);
    DLSEncodeObject(aCoder, sourceAttribute);
    DLSEncodeObject(aCoder, destinationClass);
    DLSEncodeObject(aCoder, destinationViewID);
    DLSEncodeObject(aCoder, destinationAttribute);
    DLSEncodeDouble(aCoder, constant);
    DLSEncodeDouble(aCoder, multiplier);
    DLSEncodeDouble(aCoder, priority);
    DLSEncodeBool(aCoder, active);
}

- (BOOL)isEqual:(id)object {
    if([object isKindOfClass:[DLSConstraintDescription class]]) {
        DLSConstraintDescription* description = object;
        return [description.constraintID isEqualToString:self.constraintID];
    }
    else {
        return false;
    }
}

- (NSUInteger)hash {
    return self.constraintID.hash ^ self.constraintID.hash;
}

@end
