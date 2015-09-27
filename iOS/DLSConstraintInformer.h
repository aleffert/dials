//
//  DLSConstraintInformer.h
//  Dials
//
//  Created by Akiva Leffert on 9/27/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DLSAuxiliaryConstraintInformation;

NS_ASSUME_NONNULL_BEGIN

@protocol DLSConstraintInformer <NSObject>

- (nullable DLSAuxiliaryConstraintInformation*)infoForConstraint:(NSLayoutConstraint*)constraint;

@end

NS_ASSUME_NONNULL_END
