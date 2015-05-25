//
//  DLSDescribable.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSPropertyDescription;

@protocol DLSDescriptionContext;
@protocol DLSValueExchanger;

@protocol DLSDescribable <NSObject>

/// Must call super
+ (void)dls_describe:(id <DLSDescriptionContext>)context;

@end
