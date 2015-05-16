//
//  DLSNetworkRequestsPlugin.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 5/1/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Dials/DLSPlugin.h>


/// Plugin that tracks all outgoing network requests
/// that go through the URL loading system.
/// Desktop side displays information like request length, error,
/// status code and sent and received data
@interface DLSNetworkRequestsPlugin : NSObject <DLSPlugin>

@end
