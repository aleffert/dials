//
//  DLSValueMapper.m
//  Dials
//
//  Created by Akiva Leffert on 5/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSValueMapper.h"

#import "DLSColorEditor.h"
#import "DLSFloatArrayEditor.h"

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

@implementation DLSNumericDescriptionMapper

- (id)init {
    return [super initWithFrom:^(NSNumber* value) {
        return value.description;
    } to:^(NSString* value) {
        return @(value.doubleValue);
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


@interface DLSCGColorEditor (DLSDefaultMapping) <DLSDefaultEditorMapping>
@end

@implementation DLSCGColorEditor (DLSDefaultMapping)

- (DLSValueMapper*)defaultMapper {
    return [[DLSCGColorMapper alloc] init];
}

@end

@interface DLSEdgeInsetsEditor (DLSDefaultMapping) <DLSDefaultEditorMapping>
@end

@implementation DLSEdgeInsetsEditor (DLSDefaultMapping)

- (DLSValueMapper*)defaultMapper {
    return [[DLSEdgeInsetsMapper alloc] init];
}

@end

@interface DLSPointEditor (DLSDefaultMapping) <DLSDefaultEditorMapping>
@end

@implementation DLSPointEditor (DLSDefaultMapping)

- (DLSValueMapper*)defaultMapper {
    return [[DLSPointMapper alloc] init];
}

@end


@interface DLSRectEditor (DLSDefaultMapping) <DLSDefaultEditorMapping>
@end

@implementation DLSRectEditor (DLSDefaultMapping)

- (DLSValueMapper*)defaultMapper {
    return [[DLSRectMapper alloc] init];
}

@end


@interface DLSSizeEditor (DLSDefaultMapping) <DLSDefaultEditorMapping>
@end

@implementation DLSSizeEditor (DLSDefaultMapping)

- (DLSValueMapper*)defaultMapper {
    return [[DLSSizeMapper alloc] init];
}

@end



