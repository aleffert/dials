//
//  DLSConstants.h
//  DialsShared
//
//  Created by Akiva Leffert on 12/5/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

@class DLSTransform3D;

typedef UIColor DLSColor;
#else

#import <AppKit/AppKit.h>

typedef NSColor DLSColor;

#endif

extern NSString * const __nonnull DLSNetServiceName;

// Make sure all our keys are namespaced
#define DLSConstant(key) @"DLSKey" #key


// Encoders

#define DLSEncodeObject(coder, key) [coder encodeObject:self.key forKey:DLSConstant(key)]
#define DLSEncodeBool(coder, key) [coder encodeBool:self.key forKey:DLSConstant(key)]
#define DLSEncodeInteger(coder, key) [coder encodeInteger:self.key forKey:DLSConstant(key)]
#define DLSEncodeDouble(coder, key) [coder encodeDouble:self.key forKey:DLSConstant(key)]
#define DLSEncodeTransform3D(coder, key) [coder encodeObject:[[DLSTransform3D alloc] initWithTransform:self.key] forKey:DLSConstant(key)]

#if TARGET_OS_IPHONE

#define DLSEncodeRect(coder, key) [coder encodeCGRect:self.key forKey:DLSConstant(key)]
#define DLSEncodePoint(coder, key) [coder encodeCGPoint:self.key forKey:DLSConstant(key)]

#else

#define DLSEncodeRect(coder, key) [coder encodeRect:self.key forKey:DLSConstant(key)]
#define DLSEncodePoint(coder, key) [coder encodePoint:self.key forKey:DLSConstant(key)]

#endif

// Decoders

#define DLSDecodeObject(decoder, key) self.key = [decoder decodeObjectForKey:DLSConstant(key)]
#define DLSDecodeBool(decoder, key) self.key = [decoder decodeBoolForKey:DLSConstant(key)]
#define DLSDecodeInteger(decoder, key) self.key = [decoder decodeIntegerForKey:DLSConstant(key)]
#define DLSDecodeDouble(decoder, key) self.key = [decoder decodeDoubleForKey:DLSConstant(key)]
#define DLSDecodeTransform3D(decoder, key) self.key = [[decoder decodeObjectForKey:DLSConstant(key)] transform]

#if TARGET_OS_IPHONE

#define DLSDecodeRect(decoder, key) self.key = [decoder decodeCGRectForKey:DLSConstant(key)]
#define DLSDecodePoint(decoder, key) self.key = [decoder decodeCGPointForKey:DLSConstant(key)]

#else

#define DLSDecodeRect(decoder, key) self.key = [decoder decodeRectForKey:DLSConstant(key)]
#define DLSDecodePoint(decoder, key) self.key = [decoder decodePointForKey:DLSConstant(key)]

#endif