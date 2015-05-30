//
//  DLSLiveDialsMessages.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString* const DLSLiveDialsPluginName;
extern NSString* const DLSLiveDialsPluginDefaultGroup;

@class DLSLiveDial;

@interface DLSLiveDialsMessage : NSObject <NSCoding>

- (id)initWithGroup:(NSString*)group;

@property (copy, nonatomic) NSString* group;

@end

@interface DLSLiveDialsAddMessage : DLSLiveDialsMessage <NSCoding>

@property (strong, nonatomic) DLSLiveDial* dial;

@end

@interface DLSLiveDialsRemoveMessage : DLSLiveDialsMessage <NSCoding>

@property (copy, nonatomic) NSString* uuid;

@end

@interface DLSLiveDialsChangeMessage : DLSLiveDialsMessage <NSCoding>

- (id)initWithUUID:(NSString*)uuid value:(id <NSCoding> __nullable)value group:(NSString*)group;

@property (copy, nonatomic) NSString* uuid;
@property (strong, nonatomic, nullable) id <NSCoding> value;

@end


NS_ASSUME_NONNULL_END
