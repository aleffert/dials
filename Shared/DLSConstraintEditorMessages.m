//
//  DLSConstraintEditorMessages.m
//  Dials
//
//  Created by Akiva Leffert on 9/30/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import "DLSConstraintEditorMessages.h"

#import "DLSConstants.h"

@interface DLSUpdateConstraintConstantMessage ()

@property (assign, nonatomic) CGFloat constant;
@property (copy, nonatomic) NSString* constraintID;

@end

@implementation DLSUpdateConstraintConstantMessage

- (id)initWithConstraintID:(NSString *)constraintID constant:(CGFloat)constant {
    if(self != nil) {
        self.constraintID = constraintID;
        self.constant = constant;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, constraintID);
        DLSDecodeDouble(aDecoder, constant);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, constraintID);
    DLSEncodeDouble(aCoder, constant);
}

@end
