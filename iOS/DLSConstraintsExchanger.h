//
//  DLSConstraintsExchanger.h
//  Dials
//
//  Created by Akiva Leffert on 9/26/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DLSValueExchanger.h"

@protocol DLSConstraintInformer;

@interface DLSConstraintsExchanger : DLSValueExchanger

- (id)initWithInformerProvider:(NSArray<id<DLSConstraintInformer>>*(^)(void))provider;

@end
