//
//  DLSLiveDialsMessages.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const DLSLiveDialsPluginName;

@class DLSLiveDial;

@interface DLSLiveDialsAddMessage : NSObject <NSCoding>

@property (strong, nonatomic) DLSLiveDial* dial;

@end

@interface DLSLiveDialsRemoveMessage : NSObject <NSCoding>

@property (copy, nonatomic) NSString* uuid;

@end

@interface DLSLiveDialsChangeMessage : NSObject <NSCoding>

@property (copy, nonatomic) NSString* uuid;
@property (strong, nonatomic) id value;

@end
