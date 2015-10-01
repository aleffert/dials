//
//  NSLayoutConstraint+DLSUniqueness.h
//  Dials
//
//  Created by Akiva Leffert on 9/30/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (DLSUniqueness)

+ (nullable NSLayoutConstraint*)dls_constraintWithID:(NSString*)constraintID;

@property (readonly, nonatomic) NSString* dls_constraintID;

@end

NS_ASSUME_NONNULL_END
