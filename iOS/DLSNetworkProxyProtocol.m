//
//  DLSNetworkProxyProtocol.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 5/1/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSNetworkProxyProtocol.h"

// Adapted from https://github.com/sanekgusev/SGProxyingURLProtocol
static NSString* const DLSRequestProcessed = @"DLSRequestProcessed";
static id <DLSNetworkProxyProtocolDelegate> sDelegate;

@interface DLSNetworkProxyProtocol ()

@property (strong, nonatomic) NSURLConnection* underlyingConnection;
@property (strong, nonatomic) NSString* uuid;

@end

@implementation DLSNetworkProxyProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    BOOL processed = [[NSURLProtocol propertyForKey:DLSRequestProcessed inRequest:request] boolValue];
    return !processed;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (void)setDelegate:(id <DLSNetworkProxyProtocolDelegate>)delegate {
    sDelegate = delegate;
}

- (void)startLoading {
    NSMutableURLRequest *request = self.request.mutableCopy;
    [NSURLProtocol setProperty:@YES forKey:DLSRequestProcessed inRequest:request];
    self.uuid = [NSUUID UUID].UUIDString;
    self.underlyingConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [sDelegate connectionWithID:self.uuid beganRequest:self.request];
    
}
- (void)stopLoading {
    [self.underlyingConnection cancel];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[self client] URLProtocol:self didFailWithError:error];
    [sDelegate connectionWithID:self.uuid failedWithError:error];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[self client] URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[self client] URLProtocol:self didCancelAuthenticationChallenge:challenge];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:(NSURLCacheStoragePolicy)[[self request] cachePolicy]];
    [sDelegate connectionWithID:self.uuid completedWithResponse:response];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [[self client] URLProtocol:self didLoadData:data];
    [sDelegate connectionWithID:self.uuid receivedData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[self client] URLProtocolDidFinishLoading:self];
}

@end
