//
//  DLSDescriptionContext.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <objc/runtime.h>

#import "DLSDescriptionContext.h"

#import "DLSEditor.h"
#import "DLSPropertyGroup.h"
#import "DLSPropertyDescription.h"
#import "DLSValueExchanger.h"
#import "DLSValueMapper.h"

static NSString* DLSPropertyDescriptionExchangerKey = @"DLSPropertyDescriptionExchangerKey";

@implementation DLSPropertyDescription (DLSValueExtensions)

- (void)setExchanger:(DLSValueExchanger*)exchanger {
    objc_setAssociatedObject(self, &DLSPropertyDescriptionExchangerKey, exchanger, OBJC_ASSOCIATION_RETAIN);
}

- (DLSValueExchanger*)exchanger {
    return objc_getAssociatedObject(self, &DLSPropertyDescriptionExchangerKey);
}


- (DLSPropertyDescription*(^)(DLSValueMapper*))composeMapper {
    return ^(DLSValueMapper* mapper){
        self.exchanger = [self.exchanger transform:mapper];
        return self;
    };
}

- (DLSPropertyDescription*(^)(DLSValueExchanger*))setExchanger {
    return ^(DLSValueExchanger* exchanger){
        self.exchanger = exchanger;
        return self;
    };
}

@end

DLSPropertyDescription* DLSProperty(NSString* name, id <DLSEditor> editor) {
    DLSPropertyDescription* description = [DLSPropertyDescription propertyDescriptionWithName:name editor:editor label:nil];
    description.exchanger = [[DLSKeyPathExchanger alloc] initWithKeyPath:name];
    if([editor conformsToProtocol:@protocol(DLSDefaultEditorMapping)]) {
        DLSValueMapper* mapper = [(id <DLSDefaultEditorMapping>)editor defaultMapper];
        description.composeMapper(mapper);
    }
    return description;
}
