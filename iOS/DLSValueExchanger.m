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

@interface DLSValueMapper ()

@property (copy, nonatomic) DLSMapper to;
@property (copy, nonatomic) DLSMapper from;

@end

@implementation DLSValueMapper

- (id)initWithFrom:(DLSMapper)from to:(DLSMapper)to {
    self = [super init];
    if(self != nil) {
        self.from = from;
        self.to  = to;
    }
    return self;
}

@end

@interface DLSValueExchanger ()

@property (copy, nonatomic) DLSValueFrom(^from)(id);
@property (copy, nonatomic) DLSValueTo(^to)(id);

@end

@implementation DLSValueExchanger

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

@implementation DLSCGColorMapper

- (id)init {
    return [super initWithFrom:^(id color) {
        return [UIColor colorWithCGColor:(__bridge CGColorRef)color];
    } to:^(UIColor* color) {
        return (__bridge id)color.CGColor;
    }];
}

@end


@implementation DLSViewControllerClassExchanger

- (DLSPropertyWrapper*)wrapperFromObject:(id)object {
    return [[DLSPropertyWrapper alloc] initWithGetter:^id {
        
        id parent = [object nextResponder];
        while (parent != nil && ![parent isKindOfClass:[UIViewController class]]) {
            parent = [parent nextResponder];
        }
        // Skip the module name
        return [parent class] ? [[NSStringFromClass([parent class]) componentsSeparatedByString:@"."] lastObject] : @"None";
    } setter:^(id value) {
        // nothing to do
    }];
}

@end


@implementation DLSEdgeInsetsMapper

- (id)init {
    return [self initWithFrom:^(NSValue* value) {
        return DLSEncodeUIEdgeInsets([value UIEdgeInsetsValue]);
    }to:^(NSDictionary* value) {
        return [NSValue valueWithUIEdgeInsets:DLSDecodeUIEdgeInsets(value)];
    }];
}

@end

@implementation DLSPointMapper

- (id)init {
    return [self initWithFrom:^(NSValue* value) {
        return DLSEncodeCGPoint([value CGPointValue]);
    }to:^(NSDictionary* value) {
        return [NSValue valueWithCGPoint:DLSDecodeCGPoint(value)];
    }];
}

@end

@implementation DLSRectMapper

- (id)init {
    return [self initWithFrom:^(NSValue* value) {
        return DLSEncodeCGRect([value CGRectValue]);
    }to:^(NSDictionary* value) {
        return [NSValue valueWithCGRect:DLSDecodeCGRect(value)];
    }];
}

@end

@implementation DLSSizeMapper

- (id)init {
    return [self initWithFrom:^(NSValue* value) {
        return DLSEncodeCGSize([value CGSizeValue]);
    }to:^(NSDictionary* value) {
        return [NSValue valueWithCGSize:DLSDecodeCGSize(value)];
    }];
}

@end
