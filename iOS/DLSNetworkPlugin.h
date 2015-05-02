//
//  DLSNetworkPlugin.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 5/1/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Dials/DLSPlugin.h>

@interface DLSNetworkPlugin : NSObject <DLSPlugin>

@end


@interface DLSNetworkPlugin (Private)

- (void)connectionWithID:(NSString*)connectionID beganRequest:(NSURLRequest*)request;
- (void)connectionWithID:(NSString*)connectionID sentData:(NSData*)data;
- (void)connectionWithID:(NSString *)connectionID compl
- (void)connectionWithID:(NSString*)connectionID failedWithError:(NSError*)error;

@end