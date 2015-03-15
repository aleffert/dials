//
//  DLSPropertyDescription.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSPropertyDescription.h"

#import "DLSValueExchanger.h"

@interface DLSPropertyDescription ()

@property (strong, nonatomic) id <DLSTypeDescription> typeDescription;
@property (strong, nonatomic) id <DLSValueExchanger> valueExchanger;
@property (copy, nonatomic) NSString* name;

@end

@implementation DLSPropertyDescription

+ (DLSPropertyDescription*)propertyDescriptionWithName:(NSString*)name type:(id <DLSTypeDescription>)type exchanger:(id <DLSValueExchanger>)exchanger {
    DLSPropertyDescription* description = [[DLSPropertyDescription alloc] init];
    description.name = name;
    description.typeDescription = type;
    description.valueExchanger = exchanger;
    return description;
}

@end

DLSPropertyDescription* DLSKeyPathProperty(NSString* name, id <DLSTypeDescription> description) {
    return [DLSPropertyDescription propertyDescriptionWithName:name type:description exchanger:[DLSKeyPathExchanger exchangerWithKeyPath:name]];
}