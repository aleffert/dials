//
//  DLSValueExchanger.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 1/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

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

- (id <NSCoding>)extractValueFromObject:(id)object {
    return [object valueForKeyPath:self.keyPath];
}

- (void)applyValue:(id<NSCoding>)value toObject:(id)object {
    [object setValue:value forKeyPath:self.keyPath];
}

@end
