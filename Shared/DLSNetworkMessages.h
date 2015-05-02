//
//  DLSNetworkMessages.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 5/2/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const DLSNetworkRequestsPluginName;

@interface DLSNetworkConnectionMessage : NSObject <NSCoding>

@property (copy, nonatomic) NSString* connectionID;
@property (strong, nonatomic) NSDate* timestamp;

@end

@interface DLSNetworkConnectionBeganMessage : DLSNetworkConnectionMessage <NSCoding>

@property (strong, nonatomic) NSURLRequest* request;

@end

@interface DLSNetworkConnectionFailedMessage : DLSNetworkConnectionMessage <NSCoding>

@property (strong, nonatomic) NSError* error;

@end

@interface DLSNetworkConnectionReceivedDataMessage : DLSNetworkConnectionMessage <NSCoding>

@property (strong, nonatomic) NSData* data;

@end

@interface DLSNetworkConnectionCompletedMessage : DLSNetworkConnectionMessage <NSCoding>

@property (strong, nonatomic) NSURLResponse* response;

@end