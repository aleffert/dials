//
//  DLSValueExchanger.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 1/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DLSValueExchanger.h"

#import "DLSFloatArrayEditor.h"
#import "DLSPropertyWrapper.h"
#import "DLSValueMapper.h"

@interface DLSValueExchanger ()

@property (copy, nonatomic) DLSValueFrom(^from)(id);
@property (copy, nonatomic) DLSValueTo(^to)(id);

@end

@implementation DLSValueExchanger

- (id)init {
    self = [self initWithFrom:^DLSValueFrom(id object) {
            return ^id{
                return @(0);
            };
    } to:^DLSValueTo (id object) {
        return ^(id value) {
            // do nothing
        };
    }];
    return self;
}

- (id)initWithFrom:(DLSValueFrom(^)(id))from to:(DLSValueTo(^)(id))to {
    self = [super init];
    if(self != nil) {
        self.from = from;
        self.to = to;
    }
    return self;
}

- (DLSPropertyWrapper*)wrapperFromObject:(id __nonnull)object {
    return [[DLSPropertyWrapper alloc] initWithGetter:self.from(object) setter:self.to(object)];
}

- (DLSValueExchanger*)transform:(DLSValueMapper*)mapper {
    return [[DLSValueExchanger alloc] initWithFrom:^DLSValueFrom(id object) {
        return ^{
            return mapper.from(self.from(object)());
        };
        return self.from(mapper.from(object));
    } to:^DLSValueTo(id object) {
        return ^(id value) {
            self.to(object)(mapper.to(value));
        };
    }];
}

@end

@interface DLSKeyPathExchanger ()

@end

@implementation DLSKeyPathExchanger

- (id)initWithKeyPath:(NSString*)keyPath {
    return [super initWithFrom:^DLSValueFrom(id object) {
        return [[DLSPropertyWrapper alloc] initWithKeyPath:keyPath object:object].getter;
    } to:^DLSValueTo(id object) {
        return [[DLSPropertyWrapper alloc] initWithKeyPath:keyPath object:object].setter;
    }];
}

@end


@implementation DLSViewControllerClassExchanger

- (id)init {
    self = [super initWithFrom:^DLSValueFrom (id object) {
        return ^{
            id parent = [object nextResponder];
            while (parent != nil && ![parent isKindOfClass:[UIViewController class]]) {
                parent = [parent nextResponder];
            }
            // Skip the module name
            return [parent class] ? [[NSStringFromClass([parent class]) componentsSeparatedByString:@"."] lastObject] : @"None";
        };
    } to:^DLSValueTo(id _) {
        return ^(id _) {
        // nothing to do
        };
    }];
    
    return self;
}
@end

@implementation DLSTriggerLayoutExchanger

- (id)init {
    self = [super initWithFrom:^DLSValueFrom (id object) {
        return ^{
            return @(0);
        };
    } to:^DLSValueTo (id object) {
        return ^(id _) {
            if([object isKindOfClass:[UIView class]]) {
                [object setNeedsLayout];
                [object layoutIfNeeded];
            }
        };
    }];
    return self;
}

@end
