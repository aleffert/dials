//
//  DLSValueExchanger.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 1/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSValueExchanger <NSObject>

- (id)extractValueFromObject:(id)object;
- (void)applyValue:(id)value toObject:(id)object;

@end

@interface DLSKeyPathExchanger : NSObject <DLSValueExchanger>

+ (instancetype)keyPathExchangerWithKeyPath:(NSString*)keyPath;

@end

// Wraps up a CGColor so that everything who sees it gets a UIColor
@interface DLSCGColorCoercionExchanger : NSObject <DLSValueExchanger>

- (id)initWithBackingExchanger:(id <DLSValueExchanger>)exchanger;

@end

@interface DLSViewControllerClassExchanger : NSObject <DLSValueExchanger>

@end