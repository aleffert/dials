//
//  DLSConstraintInformer.h
//  Dials
//
//  Created by Akiva Leffert on 9/27/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DLSAuxiliaryConstraintInformation;

NS_ASSUME_NONNULL_BEGIN

@protocol DLSConstraintInformer <NSObject>

- (nullable id<DLSAuxiliaryConstraintInformation>)infoForConstraint:(NSLayoutConstraint*)constraint;

@end

NS_ASSUME_NONNULL_END
