//
//  DLSDescriptionContext.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <objc/runtime.h>

#import "DLSDescriptionContext.h"

#import "DLSPropertyGroup.h"
#import "DLSPropertyDescription.h"
#import "DLSValueExchanger.h"


@interface DLSDescriptionAccumulator ()

@property (strong, nonatomic) NSMutableArray* savedGroups;

@end

@implementation DLSDescriptionAccumulator

- (id)init {
    self = [super init];
    if(self != nil) {
        self.savedGroups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addGroupWithName:(NSString*)name properties:(NSArray*)properties {
    DLSPropertyGroup* group = [[DLSPropertyGroup alloc] init];
    group.label = name;
    group.properties = properties;
    [self.savedGroups addObject:group];
}

- (NSArray*)groups {
    return self.savedGroups.copy;
}

@end

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
    return description;
}
