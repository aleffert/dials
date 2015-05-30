//
//  DLSPopupEditor.m
//  Dials
//
//  Created by Akiva Leffert on 5/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSPopupEditor.h"

#import "DLSConstants.h"

@implementation DLSPopupOption

- (id)initWithLabel:(NSString * __nonnull)label value:(id __nonnull)value {
    self = [super init];
    if(self != nil) {
        self.label = label;
        self.value = value;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, label);
        DLSDecodeObject(aDecoder, value);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, label);
    DLSEncodeObject(aCoder, value);
}

@end

@interface DLSPopupEditor ()

@property (copy, nonatomic) NSArray* options;

@end

@implementation DLSPopupEditor

- (id)initWithPopupOptions:(NSArray * __nonnull)options {
    self = [super init];
    if(self != nil) {
        self.options = options;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, options);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, options);
}

@end


