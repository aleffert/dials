//
//  DLSValueExchanger.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 1/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DLSValueExchanger.h"

@interface DLSKeyPathExchanger ()

@property (copy, nonatomic) NSString* keyPath;

@end

@implementation DLSKeyPathExchanger

+ (instancetype)keyPathExchangerWithKeyPath:(NSString *)keyPath {
    DLSKeyPathExchanger* exchanger = [[DLSKeyPathExchanger alloc] init];
    exchanger.keyPath = keyPath;
    return exchanger;
}

- (id)extractValueFromObject:(id)object {
    return [object valueForKeyPath:self.keyPath];
}

- (void)applyValue:(id<NSCoding>)value toObject:(id)object {
    [object setValue:value forKeyPath:self.keyPath];
}

@end

@interface DLSCGColorCoercionExchanger ()

@property (strong, nonatomic) id <DLSValueExchanger> backing;

@end

@implementation DLSCGColorCoercionExchanger

- (id)initWithBackingExchanger:(id<DLSValueExchanger>)exchanger {
    if(self != nil) {
        self.backing = exchanger;
    }
    return self;
}

- (id)extractValueFromObject:(id)object {
    CGColorRef color = (__bridge CGColorRef)[self.backing extractValueFromObject:object];
    UIColor* result = [UIColor colorWithCGColor:color];
    return result;
}

- (void)applyValue:(id)value toObject:(id)object {
    CGColorRef color = [value CGColor];
    [self.backing applyValue:(__bridge id)color toObject:object];
}

@end

@implementation DLSViewControllerClassExchanger

- (id)extractValueFromObject:(id)object {
    id parent = [object nextResponder];
    while (parent != nil && ![parent isKindOfClass:[UIViewController class]]) {
        parent = [parent nextResponder];
    }
    // Skip the module name
    return [parent class] ? [[NSStringFromClass([parent class]) componentsSeparatedByString:@"."] lastObject] : @"None";
}

- (void)applyValue:(id)value toObject:(id)object {
    // nothing to do
}

@end