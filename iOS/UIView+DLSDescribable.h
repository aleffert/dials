//
//  UIView+DLSDescribable.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Dials/DLSDescribable.h>

@interface UIView (DLSDescribable) <DLSDescribable>

+ (void)dls_describe:(id<DLSDescriptionContext>)context __attribute__((objc_requires_super));

@end
