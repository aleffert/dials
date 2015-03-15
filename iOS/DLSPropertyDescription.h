//
//  DLSPropertyDescription.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSTypeDescription;
@protocol DLSValueExchanger;

@interface DLSPropertyDescription : NSObject

+ (DLSPropertyDescription*)propertyDescriptionWithName:(NSString*)name type:(id <DLSTypeDescription>)type exchanger:(id <DLSValueExchanger>)exchanger;

@property (readonly, strong, nonatomic) id <DLSTypeDescription> typeDescription;
@property (readonly, strong, nonatomic) id <DLSValueExchanger> valueExchanger;
@property (readonly, copy, nonatomic) NSString* name;

@end

DLSPropertyDescription* DLSKeyPathProperty(NSString* name, id <DLSTypeDescription> description);