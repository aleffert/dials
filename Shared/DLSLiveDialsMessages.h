//
//  DLSLiveDialsMessages.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const __nonnull DLSLiveDialsPluginName;
extern NSString* const __nonnull DLSLiveDialsPluginDefaultGroup;

@class DLSLiveDial;

@interface DLSLiveDialsMessage : NSObject <NSCoding>

- (nonnull id)initWithGroup:(NSString* __nonnull)group;

@property (copy, nonatomic, nonnull) NSString* group;

@end

@interface DLSLiveDialsAddMessage : DLSLiveDialsMessage <NSCoding>

@property (strong, nonatomic, nonnull) DLSLiveDial* dial;

@end

@interface DLSLiveDialsRemoveMessage : DLSLiveDialsMessage <NSCoding>

@property (copy, nonatomic, nonnull) NSString* uuid;

@end

@interface DLSLiveDialsChangeMessage : DLSLiveDialsMessage <NSCoding>

- (nonnull id)initWithUUID:(NSString* __nonnull)uuid value:(id <NSCoding> __nullable)value group:(NSString* __nonnull)group;

@property (copy, nonatomic, nonnull) NSString* uuid;
@property (strong, nonatomic, nullable) id <NSCoding> value;

@end
