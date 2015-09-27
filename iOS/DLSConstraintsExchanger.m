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
#import "DLSConstraintInformer.h"


NSArray<DLSConstraintDescription*>* DLSExtractConstraintsForView(UIView* view, NSArray<id<DLSConstraintInformer>> *(^provider)(void)) {
    NSArray<NSLayoutConstraint*>* horizontal = [view constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal];
    NSArray<NSLayoutConstraint*>* vertical = [view constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical];
    NSArray<NSLayoutConstraint*>* constraints = [horizontal arrayByAddingObjectsFromArray:vertical];
    NSMutableArray<DLSConstraintDescription*>* result = [[NSMutableArray alloc] init];
    for(NSLayoutConstraint* constraint in constraints) {
        if([constraint.firstItem isEqual:view] || [constraint.secondItem isEqual:view]) {
            NSMutableArray<DLSAuxiliaryConstraintInformation*>* extras = [[NSMutableArray alloc] init];
            for(id <DLSConstraintInformer> informer in provider()) {
                DLSAuxiliaryConstraintInformation* info = [informer infoForConstraint:constraint];
                if(info != nil) {
                    [extras addObject:info];
                }
            }
            DLSConstraintDescription* description = [[DLSConstraintDescription alloc] initWithView:view constraint:constraint extras:extras];
            [result addObject:description];
        }
    }
    return result;
}

@implementation DLSConstraintsExchanger

- (id)initWithInformerProvider:(NSArray<id<DLSConstraintInformer>> *(^)(void))provider {
    self = [super initWithFrom:^DLSValueFrom (id object) {
        return ^{
            if([object isKindOfClass:[UIView class]]) {
                UIView* view = object;
                NSArray<DLSConstraintDescription*>* constraints = DLSExtractConstraintsForView(view, provider);
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

@end
