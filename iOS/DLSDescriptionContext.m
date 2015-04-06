//
//  DLSDescriptionContext.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSDescriptionContext.h"

@implementation DLSDescriptionGroup

@end

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
    DLSDescriptionGroup* group = [[DLSDescriptionGroup alloc] init];
    group.displayName = name;
    group.properties = properties;
    [self.savedGroups addObject:group];
}

- (NSArray*)groups {
    return self.savedGroups.copy;
}

@end
