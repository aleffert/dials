//
//  DLSPropertyDescription.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSEditorDescription;
@protocol DLSValueExchanger;

@interface DLSPropertyDescription : NSObject

+ (DLSPropertyDescription*)propertyDescriptionWithName:(NSString*)name editor:(id <DLSEditorDescription>)editor exchanger:(id <DLSValueExchanger>)valueExchanger;

@property (readonly, strong, nonatomic) id <DLSEditorDescription> editorDescription;
@property (readonly, strong, nonatomic) DLSPropertyWrapper* valueExchanger;
/// Should be unique within a class and its parents
@property (readonly, copy, nonatomic) NSString* name;
/// Can be anything. If nil, the "name" property will be used for display
@property (readonly, copy, nonatomic) NSString* displayName;

@end

DLSPropertyDescription* DLSKeyPathProperty(NSString* name, id <DLSEditorDescription> description);