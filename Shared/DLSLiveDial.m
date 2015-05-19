//
//  DLSLiveDial.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/15/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSLiveDial.h"

#import "DLSConstants.h"

@implementation DLSLiveDial

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, label);
        DLSDecodeObject(aDecoder, editor);
        DLSDecodeObject(aDecoder, group);
        DLSDecodeObject(aDecoder, uuid);
        DLSDecodeObject(aDecoder, value);
        
        DLSDecodeBool(aDecoder, canSave);
        
        DLSDecodeObject(aDecoder, file);
        DLSDecodeInteger(aDecoder, line);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, group);
    DLSEncodeObject(aCoder, label);
    DLSEncodeObject(aCoder, editor);
    DLSEncodeObject(aCoder, uuid);
    DLSEncodeObject(aCoder, value);
    
    DLSEncodeBool(aCoder, canSave);
    
    DLSEncodeObject(aCoder, file);
    DLSEncodeInteger(aCoder, line);
}

@end
