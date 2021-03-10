//
//  GitSecurity.h
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import <dlfcn.h>
#include <mach/mach_init.h>
#include <mach/vm_map.h>
#include <sys/stat.h>
#import "RNCryptor iOS.h"

typedef NS_ENUM(NSUInteger, LNPasscodeStatus){
    /* The passcode status was unknown */
    LNPasscodeStatusUnknown   = 0,
    /* The passcode is enabled */
    LNPasscodeStatusEnabled   = 1,
    /* The passcode is disabled */
    LNPasscodeStatusDisabled  = 2
};


@interface GitSecurity : NSData


#pragma mark BASE64 ENCODING / DECODING
/**
 *  Encode a NSData into Base64.
 *
 *  @param rawBytes The NSData to be encoded.
 *
 *  @return The encoded Base64 data in NSString.
 */
+ (NSString*) encode:(NSData*) rawBytes;

/**
 *  Decode a Base64 string into NSData.
 *
 *  @param string The Base64 string.
 *
 *  @return The decoded NSData.
 */
+ (NSData*) decode:(NSString*) string;


#pragma mark AES 128 ENCRYPT / DECRYPT
/**
 *  Encrypt with AES128.
 *
 *  @param key   The encryption key.
 *  @param _data The data to be encrypted.
 *
 *  @return Encrypted data.
 */
+ (NSData *)AES128EncryptWithKey:(NSString *)key withData:(NSData*)_data;

/**
 *  Decode and then decrypt an encrypted data.
 *
 *  @param stringToBeDecrypted The encoded encrypted NSString to be decrypted.
 *  @param decryptKey          The decryption key.
 *
 *  @return The string that has been fully decoded and decrypted.
 */
+ (NSString *)getDecodedDecryptedString:(NSString *)stringToBeDecrypted :(NSString*)decryptKey;


#pragma mark JAILBREAK DETECTION
/**
 *  Detect if a device is jail broken.
 *
 *  @return Boolean indicating whether the device is jail broken.
 */
+ (BOOL)jailbreakDetection;


#pragma mark PASSCODE STATUS DETECTION
/**
 *  Determines if the device supports the `passcodeStatus` check. Passcode check is only supported on iOS 8.
 */
+ (BOOL)passcodeStatusSupported;

/**
 *  Determines if the device set any passcode.
 */
+ (BOOL)isPasscodeSet;

/**
 *  Checks and returns the devices current passcode status.
 *  If `passcodeStatusSupported` returns NO then `LNPasscodeStatusUnknown` will be returned.
 */
+ (LNPasscodeStatus)passcodeStatus;

#pragma mark SHA256
/**
 *  Perform SHA256 encryption : SHA256(Name + Salt + (Hash(PIN from user))) -- Default Pattern
 *
 *  @param pinHash One of the combination Integer, usually provide by userInput, Eg: (Pin HashValue)
 *  @param name    One of the combination String, usually provide by userInput, Eg: Username
 *  @param salt   One of the combination String, random generated and must always same, Eg: Username
 *
 *  @return the value or nil if an error occurs.
 */
+ (NSString *)securedSHA256DigestHashForPIN:(NSUInteger)pinHash name:(NSString *)name salt:(NSString *)salt;
/**
 *  User defined own pattern
 */
+ (NSString*)computeSHA256DigestForString:(NSString*)input;

#pragma markAES 256
/*!
 Encrypt data to encrypted-NSData with AES Cryptor
 
 @param data Raw Data to be encrypted.
 @param privateKey Cryptor private key.
 @param error Cached error if Cryptor Failed
 
 @return NSData Return encrypted data.
 */
+ (NSData *)encryptDataAES256:(NSData *)data password:(NSString *)privateKey error:(NSError **)error;
+ (NSData *)encryptData:(NSData *)data withSettings:(RNCryptorSettings)settings password:(NSString *)privateKey error:(NSError **)error;

/*!
 Decrypt encrypted-NSData to data with AES Cryptor
 
 @param data Encrypted Data to be decrypt.
 @param privateKey Cryptor private key.
 @param error Cached error if Cryptor Failed
 
 @return NSData Return decrypted Object.
 */
+ (NSData *)decryptDataAES256:(NSData *)data password:(NSString *)privateKey error:(NSError **)error;
+ (NSData *)decryptData:(NSData *)data withSettings:(RNCryptorSettings)settings password:(NSString *)privateKey error:(NSError **)error;

#pragma mark AES 256 ENCRYPT / DECRYPT
+ (NSData *)encryptedDataForData:(NSData *)data
                        password:(NSString *)password
                           error:(NSError **)error;

+ (NSData *)decrypt:(NSData *)data
           password:(NSString *)password
              error:(NSError **)error;

+ (NSData *)encrypt:(NSData *)plainText key:(NSString *)key iv:(NSString *)iv;
+ (NSData *)decrypt:(NSData *)encryptedText key:(NSString *)key iv:(NSString *)iv;

+ (NSString *)encryptPBEWithMD5AndDES:(NSString *)plainText withKey:(NSString*)encryptKey;
+ (NSString *)decryptPBEWithMD5AndDES:(NSString *)encryptedText withKey:(NSString*)decryptKey;

+ (NSString*) SHA1:(NSString *) stringToSHA;
+ (NSString*) SHA256:( NSString *) stringToSHA;
+ (NSString *) Hmac:(NSString *) stringToHmac withKey: (NSString *) key;

+ (NSString *) tripleDESEncrypt:(NSString *)stringToEncrypt withKey:(NSString *)encryptKey;
+ (NSString *) tripleDESdecryption:(NSString *)stringToDecrypt withKey:(NSString *)decryptKey;

@end
