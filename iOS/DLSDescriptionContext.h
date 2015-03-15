//
//  DLSDescriptionContext.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLSDescriptionContext <NSObject>

- (void)addGroupWithName:(NSString*)name properties:(NSArray*)properties;

@end

@interface DLSDescriptionGroups : NSObject <DLSDescriptionContext>

@property (readonly, nonatomic) NSArray* groups;

@end
