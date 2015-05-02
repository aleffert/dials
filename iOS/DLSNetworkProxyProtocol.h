//
//  DLSNetworkProxyProtocol.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 5/1/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSNetworkProxyProtocolDelegate

- (void)connectionWithID:(NSString*)connectionID beganRequest:(NSURLRequest*)request;
- (void)connectionWithID:(NSString*)connectionID receivedData:(NSData*)data;
- (void)connectionWithID:(NSString*)connectionID completedWithResponse:(NSURLResponse*)response;
- (void)connectionWithID:(NSString*)connectionID failedWithError:(NSError*)error;

@end

@interface DLSNetworkProxyProtocol : NSURLProtocol

+ (void)setDelegate:(id <DLSNetworkProxyProtocolDelegate>)delegate;

@end
