//
//  DLSConstraintsExchanger.m
//  Dials
//
//  Created by Akiva Leffert on 9/26/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DLSConstraintsExchanger.h"
#import "DLSConstraintDescription.h"

@implementation DLSConstraintsExchanger

- (id)init {
    self = [super initWithFrom:^DLSValueFrom (id object) {
        return ^{
            if([object isKindOfClass:[UIView class]]) {
                UIView* view = object;
                NSArray<DLSConstraintDescription*>* constraints = [self extractConstraintsForView:view];
                return constraints;
            }
            else {
                NSArray<DLSConstraintDescription*>* constraints = @[];
                return constraints;
            }
        };
    } to:^DLSValueTo(id _) {
        return ^(id _) {
            // nothing to do
        };
    }];
    
    return self;
}

- (NSArray<DLSConstraintDescription*>*)extractConstraintsForView:(UIView*)view {
    NSArray<NSLayoutConstraint*>* horizontal = [view constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal];
    NSArray<NSLayoutConstraint*>* vertical = [view constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical];
    NSArray<NSLayoutConstraint*>* constraints = [horizontal arrayByAddingObjectsFromArray:vertical];
    NSMutableArray<DLSConstraintDescription*>* result = [[NSMutableArray alloc] init];
    for(NSLayoutConstraint* constraint in constraints) {
        if([constraint.firstItem isEqual:view] || [constraint.secondItem isEqual:view]) {
            DLSConstraintDescription* description = [[DLSConstraintDescription alloc] initWithView:view constraint:constraint];
            [result addObject:description];
        }
    }
    return result;
}

@end
