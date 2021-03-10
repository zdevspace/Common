//
//  RNDecryptor.h
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNCryptor.h"


@interface RNDecryptor : RNCryptor

- (RNDecryptor *)initWithEncryptionKey:(NSData *)encryptionKey
                               HMACKey:(NSData *)HMACKey
                               handler:(RNCryptorHandler)handler;

- (RNDecryptor *)initWithPassword:(NSString *)password
                          handler:(RNCryptorHandler)handler;

+ (NSData *)decryptData:(NSData *)theCipherText withSettings:(RNCryptorSettings)settings password:(NSString *)aPassword error:(NSError **)anError;
+ (NSData *)decryptData:(NSData *)theCipherText withSettings:(RNCryptorSettings)settings encryptionKey:(NSData *)encryptionKey HMACKey:(NSData *)HMACKey error:(NSError **)anError;

+ (NSData *)decryptData:(NSData *)data withPassword:(NSString *)password error:(NSError **)error;
+ (NSData *)decryptData:(NSData *)data withEncryptionKey:(NSData *)encryptionKey HMACKey:(NSData *)HMACKey error:(NSError **)error;

@end
