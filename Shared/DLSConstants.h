//
//  DLSConstants.h
//  DialsShared
//
//  Created by Akiva Leffert on 12/5/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const DLSNetServiceName;

#define DLSConstant(key) @"DLSKey" #key


#define DLSEncodeObject(coder, key) [coder encodeObject:self.key forKey:DLSConstant(key)]
#define DLSEncodeBool(coder, key) [coder encodeBool:self.key forKey:DLSConstant(key)]
#define DLSEncodeInteger(coder, key) [coder encodeInteger:self.key forKey:DLSConstant(key)]
#define DLSEncodeDouble(coder, key) [coder encodeDouble:self.key forKey:DLSConstant(key)]


#define DLSDecodeObject(decoder, key) self.key = [decoder decodeObjectForKey:DLSConstant(key)]
#define DLSDecodeBool(decoder, key) self.key = [decoder decodeBoolForKey:DLSConstant(key)]
#define DLSDecodeInteger(decoder, key) self.key = [decoder decodeIntegerForKey:DLSConstant(key)]
#define DLSDecodeDouble(decoder, key) self.key = [decoder decodeDoubleForKey:DLSConstant(key)]