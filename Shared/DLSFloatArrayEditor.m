//
//  DLSFloatArrayEditor.m
//  Dials
//
//  Created by Akiva Leffert on 5/22/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSFloatArrayEditor.h"

#import "DLSConstants.h"

@interface DLSFloatArrayEditor ()

@property (copy, nonatomic) NSArray* labels;
@property (copy, nonatomic) NSString* constructor;

@end

@implementation DLSFloatArrayEditor


- (id)initWithLabels:(NSArray*)labels constructor:(NSString*)constructor {
    self = [super init];
    if(self != nil) {
        self.labels = labels;
        self.constructor = constructor;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, labels);
        DLSDecodeObject(aDecoder, constructor);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, labels);
    DLSEncodeObject(aCoder, constructor);
}

@end

@implementation DLSPointEditor

- (id)init {
    return [self initWithLabels:@[@"x", @"y"] constructor:@"CGPointMake({x}, {y})"];
}

@end


@implementation DLSSizeEditor

- (id)init {
    return [self initWithLabels:@[@"width", @"height"] constructor:@"CGSizeMake({width}, {height})"];
}

@end

@implementation DLSRectEditor

- (id)init {
    return [self initWithLabels:@[@"x", @"y", @"width", @"height"] constructor:@"CGRectMake({width}, {height})"];
}

@end

@implementation DLSEdgeInsetsEditor

- (id)init {
    return [self initWithLabels:@[@"top", @"left", @"bottom", @"right"] constructor:@"UIEdgeInsetsMake({top}, {left}, {bottom}, {right})"];
}
@end

