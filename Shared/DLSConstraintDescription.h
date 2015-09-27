//
//  DLSConstraintDescription.h
//  Dials+SnapKit
//
//  Created by Akiva Leffert on 9/25/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class DLSAuxiliaryConstraintInformation;

@interface DLSConstraintDescription : NSObject <NSCoding>

#if TARGET_OS_IPHONE
- (id)initWithView:(UIView*)view constraint:(NSLayoutConstraint*)constraint extras:(NSArray<DLSAuxiliaryConstraintInformation*>*)extras;
#endif

@property (copy, nonatomic) NSString* affectedViewID;
@property (copy, nonatomic) NSString* constraintID;

@property (copy, nonatomic) NSString* relation;

@property (copy, nonatomic) NSString* sourceClass;
@property (copy, nonatomic, nullable) NSString* sourceViewID;
@property (copy, nonatomic) NSString* sourceAttribute;

@property (copy, nonatomic, nullable) NSString* destinationClass;
@property (copy, nonatomic, nullable) NSString* destinationViewID;
@property (copy, nonatomic, nullable) NSString* destinationAttribute;

@property (assign, nonatomic) CGFloat constant;
@property (assign, nonatomic) CGFloat multiplier;
@property (assign, nonatomic) CGFloat priority;
@property (assign, nonatomic) BOOL active;

@property (copy, nonatomic) NSArray<DLSAuxiliaryConstraintInformation*>* extras;

@end

NS_ASSUME_NONNULL_END
