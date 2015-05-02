//
//  DLSPropertyDescription.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSPropertyDescription.h"

#import "DLSConstants.h"

@interface DLSPropertyDescription ()

@property (strong, nonatomic) id <DLSEditorDescription> editorDescription;
@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* displayName;

@end

@implementation DLSPropertyDescription

+ (DLSPropertyDescription*)propertyDescriptionWithName:(NSString *)name editor:(id<DLSEditorDescription>)editor {
    return [self propertyDescriptionWithName:name editor:editor displayName:name];
}

+ (DLSPropertyDescription*)propertyDescriptionWithName:(NSString*)name editor:(id <DLSEditorDescription>)type displayName:(NSString *)displayName {
    DLSPropertyDescription* description = [[DLSPropertyDescription alloc] init];
    description.name = name;
    description.displayName = displayName;
    description.editorDescription = type;
    return description;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self != nil) {
        DLSDecodeObject(aDecoder, name);
        DLSDecodeObject(aDecoder, displayName);
        DLSDecodeObject(aDecoder, editorDescription);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, name);
    DLSEncodeObject(aCoder, displayName);
    DLSEncodeObject(aCoder, editorDescription);
}

@end

DLSPropertyDescription* DLSProperty(NSString* name, id <DLSEditorDescription> description) {
    NSError* error = nil;
    NSRegularExpression* expression = [[NSRegularExpression alloc] initWithPattern:@"([A-Z])" options:0 error:&error];
    NSString* spaced = [name stringByReplacingOccurrencesOfString:@"." withString:@" "];
    NSCAssert(error == nil, @"Error creating expression to match capitals: %@", error);
    NSString* niceName = [[expression stringByReplacingMatchesInString:spaced options:0 range:NSMakeRange(0, spaced.length) withTemplate:@" $1"] capitalizedString];
    return [DLSPropertyDescription propertyDescriptionWithName:name editor:description displayName:niceName];
}

DLSPropertyDescription* DLSDisplayProperty(NSString* displayName, NSString* name, id <DLSEditorDescription> description) {
    return [DLSPropertyDescription propertyDescriptionWithName:name editor:description displayName:displayName];
}