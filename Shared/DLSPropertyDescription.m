//
//  DLSPropertyDescription.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSPropertyDescription.h"

#import "DLSConstants.h"

NSString* DLSNiceLabelWithName(NSString* name) {
    NSError* error = nil;
    NSString* split = [[name componentsSeparatedByString:@"."] lastObject];
    NSRegularExpression* expression = [[NSRegularExpression alloc] initWithPattern:@"([A-Z])" options:0 error:&error];
    NSCAssert(error == nil, @"Error creating expression to match capitals: %@", error);
    NSString* niceName = [[expression stringByReplacingMatchesInString:split options:0 range:NSMakeRange(0, split.length) withTemplate:@" $1"] capitalizedString];

    return niceName;
}

@interface DLSPropertyDescription ()

@property (strong, nonatomic) id <DLSEditor> editor;
@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* label;

@end

@implementation DLSPropertyDescription

+ (DLSPropertyDescription*)propertyDescriptionWithName:(NSString *)name editor:(id<DLSEditor>)editor {
    return [self propertyDescriptionWithName:name editor:editor label:name];
}

+ (DLSPropertyDescription*)propertyDescriptionWithName:(NSString*)name editor:(id <DLSEditor>)type label:(NSString *)label {
    DLSPropertyDescription* description = [[DLSPropertyDescription alloc] init];
    description.name = name;
    description.label = label ?: DLSNiceLabelWithName(name);
    description.editor = type;
    return description;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self != nil) {
        DLSDecodeObject(aDecoder, name);
        DLSDecodeObject(aDecoder, label);
        DLSDecodeObject(aDecoder, editor);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, name);
    DLSEncodeObject(aCoder, label);
    DLSEncodeObject(aCoder, editor);
}

- (DLSPropertyDescription* (^)(NSString*))setLabel {
    return ^(NSString* label) {
        self.label = label;
        return self;
    };
}

@end
