//
//  DLSDescriptionAccumulator.m
//  Dials
//
//  Created by Akiva Leffert on 5/30/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSDescriptionAccumulator.h"

#import "DLSPropertyGroup.h"

@interface DLSDescriptionAccumulator ()

@property (strong, nonatomic) NSMutableArray<DLSPropertyGroup *>* savedGroups;

@end

@implementation DLSDescriptionAccumulator

- (id)init {
    self = [super init];
    if(self != nil) {
        self.savedGroups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addGroupWithName:(NSString*)name properties:(NSArray<DLSPropertyDescription*>*)properties {
    DLSPropertyGroup* group = [[DLSPropertyGroup alloc] init];
    group.label = name;
    group.properties = properties;
    [self.savedGroups addObject:group];
}

- (NSArray*)groups {
    return self.savedGroups.copy;
}

@end
