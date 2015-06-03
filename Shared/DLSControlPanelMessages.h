//
//  DLSControlPanelMessages.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString* const DLSControlPanelPluginIdentifier;
extern NSString* const DLSControlPanelPluginDefaultGroup;

@class DLSControlInfo;

@interface DLSControlPanelMessage : NSObject <NSCoding>

- (id)initWithGroup:(NSString*)group;

@property (copy, nonatomic) NSString* group;

@end

@interface DLSControlPanelAddMessage : DLSControlPanelMessage <NSCoding>

@property (strong, nonatomic) DLSControlInfo* info;

@end

@interface DLSControlPanelRemoveMessage : DLSControlPanelMessage <NSCoding>

@property (copy, nonatomic) NSString* uuid;

@end

@interface DLSControlPanelChangeMessage : DLSControlPanelMessage <NSCoding>

- (id)initWithUUID:(NSString*)uuid value:(id <NSCoding> __nullable)value group:(NSString*)group;

@property (copy, nonatomic) NSString* uuid;
@property (strong, nonatomic, nullable) id <NSCoding> value;

@end


NS_ASSUME_NONNULL_END
