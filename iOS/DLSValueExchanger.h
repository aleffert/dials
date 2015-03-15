//
//  DLSValueExchanger.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 1/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSValueExchanger <NSObject>

- (id <NSCoding>)extractValueFromObject:(id)object;
- (void)applyValue:(id <NSCoding>)value toObject:(id)object;

@end

@interface DLSKeyPathExchanger : NSObject <DLSValueExchanger>

+ (instancetype)exchangerWithKeyPath:(NSString*)keyPath;

@end