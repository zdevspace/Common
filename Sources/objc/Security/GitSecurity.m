//
//  GitSecurity.m
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "GitSecurity.h"

NSString * const
kRNCryptManagerErrorDomain = @"com.ggit.mobilesdk.RNCryptManager";

const CCAlgorithm kAlgorithm = kCCAlgorithmAES128;
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger kAlgorithmIVSize = kCCBlockSizeAES128;
const NSUInteger kPBKDFSaltSize = 8;
const NSUInteger kPBKDFRounds = 10000;  // ~80ms on an iPhone 4

#define ArrayLength(x) (sizeof(x)/sizeof(*(x)))

static char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static char decodingTable[128];

@implementation GitSecurity


//===========================================================

//BASE64 DECODE / ENCODE

//===========================================================

+ (void) initialize {
    if (self == [GitSecurity class]) {
        memset(decodingTable, 0, ArrayLength(decodingTable));
        for (NSInteger i = 0; i < ArrayLength(encodingTable); i++) {
            decodingTable[encodingTable[i]] = i;
        }
    }
}

+ (NSString*) encode:(const uint8_t*) input length:(NSInteger) length {
    
    [self initialize];
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    encodingTable[(value >> 18) & 0x3F];
        output[index + 1] =                    encodingTable[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? encodingTable[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? encodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data
                                 encoding:NSASCIIStringEncoding];
}


+ (NSString*) encode:(NSData*) rawBytes {
    [self initialize];
    return [self encode:(const uint8_t*) rawBytes.bytes length:rawBytes.length];
}


+ (NSData*) decode:(const char*) string length:(NSInteger) inputLength {
    [self initialize];
    if ((string == NULL) || (inputLength % 4 != 0)) {
        return nil;
    }
    
    while (inputLength > 0 && string[inputLength - 1] == '=') {
        inputLength--;
    }
    
    NSInteger outputLength = inputLength * 3 / 4;
    NSMutableData* data = [NSMutableData dataWithLength:outputLength];
    uint8_t* output = data.mutableBytes;
    
    NSInteger inputPoint = 0;
    NSInteger outputPoint = 0;
    while (inputPoint < inputLength) {
        char i0 = string[inputPoint++];
        char i1 = string[inputPoint++];
        char i2 = inputPoint < inputLength ? string[inputPoint++] : 'A';
        char i3 = inputPoint < inputLength ? string[inputPoint++] : 'A';
        
        output[outputPoint++] = (decodingTable[i0] << 2) | (decodingTable[i1] >> 4);
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((decodingTable[i1] & 0xf) << 4) | (decodingTable[i2] >> 2);
        }
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((decodingTable[i2] & 0x3) << 6) | decodingTable[i3];
        }
    }
    
    return data;
}

+ (NSData*) decode:(NSString*) string {
    [self initialize];
    return [self decode:[string cStringUsingEncoding:NSASCIIStringEncoding] length:string.length];
}



//===========================================================

//AES 128 ENCRYPT / DECRYPT

//===========================================================

+ (NSString *)getDecodedDecryptedString:(NSString *)stringToBeDecrypted :(NSString*)decryptKey
{
    NSString *myString = @"";
    NSData *decodedDataToBeDecrypted;
    decodedDataToBeDecrypted = [self decode:stringToBeDecrypted];
    
    NSData *theData = [self AESDecryptWithKey:decodedDataToBeDecrypted Key:decryptKey];
    myString = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
    
    return myString;
}

+ (NSData *)AES128EncryptWithKey:(NSString *)key withData:(NSData*)_data
{
    // ‘key’ should be 16 bytes for AES128
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero( keyPtr, sizeof( keyPtr ) );
    
    [key getCString:keyPtr maxLength:sizeof( keyPtr ) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [_data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc( bufferSize );
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt( kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [_data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted );
    if( cryptStatus == kCCSuccess )
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    
    free( buffer );
    return nil;
}

+ (NSData *)AESDecryptWithKey:(NSData *)data
                          Key:(NSString *)key {
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    
    free(buffer);
    return nil;
}

//===========================================================

//AES 256 ENCRYPT / DECRYPT

//===========================================================

+ (NSData *)encryptedDataForData:(NSData *)data
                        password:(NSString *)password
                           error:(NSError **)error {
    
    NSData *iv;
    iv = [self getSalt:kAlgorithmIVSize];
    NSData *salt;
    salt = [self getSalt:kPBKDFSaltSize];
    
    NSData *key = [self AESKeyForPassword:password salt:salt];
    
    size_t outLength;
    NSMutableData *
    cipherData = [NSMutableData dataWithLength:data.length +
                  kAlgorithmBlockSize];
    
    CCCryptorStatus
    result = CCCrypt(kCCEncrypt, // operation
                     kAlgorithm, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     key.bytes, // key
                     key.length, // keylength
                     (iv).bytes,// iv
                     data.bytes, // dataIn
                     data.length, // dataInLength,
                     cipherData.mutableBytes, // dataOut
                     cipherData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        cipherData.length = outLength;
    }
    else {
        if (error) {
            *error = [NSError errorWithDomain:kRNCryptManagerErrorDomain
                                         code:result
                                     userInfo:nil];
        }
        return nil;
    }
    return cipherData;
}


+ (NSData *)decrypt:(NSData *)data
           password:(NSString *)password
              error:(NSError **)error {
    
    NSData *iv;
    iv = [self getSalt:kAlgorithmIVSize];
    NSData *salt;
    salt = [self getSalt:kPBKDFSaltSize];
    
    NSData *key = [self AESKeyForPassword:password salt:salt];
    
    size_t outLength;
    NSMutableData *
    cipherData = [NSMutableData dataWithLength:data.length +
                  kAlgorithmBlockSize];
    
    CCCryptorStatus
    result = CCCrypt(kCCDecrypt, // operation
                     kAlgorithm, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     key.bytes, // key
                     key.length, // keylength
                     (iv).bytes,// iv
                     data.bytes, // dataIn
                     data.length, // dataInLength,
                     cipherData.mutableBytes, // dataOut
                     cipherData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        cipherData.length = outLength;
    }
    else {
        if (error) {
            *error = [NSError errorWithDomain:kRNCryptManagerErrorDomain
                                         code:result
                                     userInfo:nil];
        }
        return nil;
    }
    
    return cipherData;
}


// ===================

+ (NSData *)getSalt:(size_t)length {
    NSMutableData *data = [NSMutableData dataWithLength:length];
    
    int result = SecRandomCopyBytes(kSecRandomDefault,
                                    length,
                                    data.mutableBytes);
    NSAssert(result == 0, @"Unable to generate random bytes: %d",
             errno);
    
    return data;
}

// ===================

// Replace this with a 10,000 hash calls if you don't have CCKeyDerivationPBKDF
+ (NSData *)AESKeyForPassword:(NSString *)password
                         salt:(NSData *)salt {
    NSMutableData *
    derivedKey = [NSMutableData dataWithLength:kAlgorithmKeySize];
    
    int
    result = CCKeyDerivationPBKDF(kCCPBKDF2,            // algorithm
                                  password.UTF8String,  // password
                                  [password lengthOfBytesUsingEncoding:NSUTF8StringEncoding],  // passwordLength
                                  salt.bytes,           // salt
                                  salt.length,          // saltLen
                                  kCCPRFHmacAlgSHA1,    // PRF
                                  kPBKDFRounds,         // rounds
                                  derivedKey.mutableBytes, // derivedKey
                                  derivedKey.length); // derivedKeyLen
    
    NSAssert(result == kCCSuccess,
             @"Unable to create AES key for password: %d", result);
    
    return derivedKey;
}

//===========================================================

// Detect JailBroken Devices

//===========================================================

+ (BOOL)jailbreakDetection
{
    NSString *filePath = @"/Applications/Cydia.app";
    NSString *filePath2 = @"/Library/MobileSubstrate/MobileSubstrate.dylib";
    NSString *filePath3 = @"/var/cache/apt";
    NSString *filePath4 = @"/var/lib/apt";
    NSString *filePath5 = @"/var/lib/cydia";
    NSString *filePath6 = @"/bin/bash";
    NSString *filePath7 = @"/bin/sh";
    NSString *filePath8 = @"/usr/sbin/sshd";
    NSString *filePath9 = @"/usr/libexec/ssh-keysign";
    NSString *filePath10 = @"/etc/ssh/sshd_config";
    NSString *filePath11 = @"/etc/apt";
    NSString *filePath12 = @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist";
    NSString *filePath13 = @"/Library/LaunchDaemons/com.openssh.sshd.plist";
    NSString *filePath14 = @"/Applications/blackra1n.app";
    NSString *filePath15 = @"/private/var/stash";
    NSString *filePath16 = @"/bin/mv";
    NSString *filePath17 = @"/private/var/lib/apt";
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath2]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath3]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath4]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath5]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath6]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath7]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath8]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath9]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath10]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath11]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath12]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath13]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath14]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath15]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath16]
        ||[[NSFileManager defaultManager] fileExistsAtPath:filePath17])
        return TRUE;
    
    struct stat s;
    stat("/etc/fstab", &s);
    
    if(s.st_size<80)
        return TRUE;
    
    if (lstat("/Applications", &s)!=0) {
        if (s.st_mode & S_IFLNK)
            return TRUE;
    }
    
    return FALSE;
}


#pragma mark - PASSCODE STATUS DETECTION
#pragma mark -
NSString * const UIDevicePasscodeKeychainService = @"UIDevice-PasscodeStatus_KeychainService";
NSString * const UIDevicePasscodeKeychainAccount = @"UIDevice-PasscodeStatus_KeychainAccount";

+ (BOOL)passcodeStatusSupported
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#endif
    
#ifdef __IPHONE_8_0
    return (&kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly != NULL);
#else
    return NO;
#endif
}

+ (BOOL)isPasscodeSet {
//    ConditionPasscode *condition = [ConditionPasscode new];
//    return (condition.passcodeStatus == LNPasscodeStatusEnabled);
    return [[self class] passcodeStatus] == LNPasscodeStatusEnabled;
}

+ (LNPasscodeStatus)passcodeStatus
{
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"-[%@ %@] - not supported in simulator", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    return LNPasscodeStatusUnknown;
#endif
    
#ifdef __IPHONE_8_0
    if (&kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly != NULL) {
        
        static NSData *password = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            password = [NSKeyedArchiver archivedDataWithRootObject:NSStringFromSelector(_cmd)];
        });
        
        NSDictionary *query = @{
                                (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                (__bridge id)kSecAttrService: UIDevicePasscodeKeychainService,
                                (__bridge id)kSecAttrAccount: UIDevicePasscodeKeychainAccount,
                                (__bridge id)kSecReturnData: @YES,
                                };
        
        CFErrorRef sacError = NULL;
        SecAccessControlRef sacObject;
        sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, kNilOptions, &sacError);
        
        // unable to create the access control item.
        if (sacObject == NULL || sacError != NULL) {
            return LNPasscodeStatusUnknown;
        }
        
        
        NSMutableDictionary *setQuery = [query mutableCopy];
        setQuery[(__bridge id) kSecValueData] = password;
        setQuery[(__bridge id) kSecAttrAccessControl] = (__bridge id) sacObject;
        
        OSStatus status;
        status = SecItemAdd((__bridge CFDictionaryRef)setQuery, NULL);
        
        // if we have the object, release it.
        if (sacObject) {
            CFRelease(sacObject);
            sacObject = NULL;
        }
        // if it failed to add the item.
        if (status == errSecDecode) {
            return LNPasscodeStatusDisabled;
        }
        
        status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
        
        // it managed to retrieve data successfully
        if (status == errSecSuccess) {
            return LNPasscodeStatusEnabled;
        }
        
        // not sure what happened, returning unknown
        return LNPasscodeStatusUnknown;
        
    } else {
        return LNPasscodeStatusUnknown;
    }
#else
    return LNPasscodeStatusUnknown;
#endif
}

#pragma mark - SHA256
#pragma mark -
// Used to help secure the PIN.
// Ideally, this is randomly generated, but to avoid the unnecessary complexity and overhead of storing the Salt separately, we will standardize on this key.
// !!KEEP IT A SECRET!!
#define SALT_HASH @"FvTivqTqZXsgLLx1v3P8TGRgFHaSsB1pvfmA2rvGadj3ZLHV0GrfxaZ84oGP8RsKdNRpxdAojXYg9iAj"

// This is where most of the magic happens (the rest of it happens in computeSHA256DigestForString: method below).
// Here we are passing in the hash of the PIN that the user entered so that we can avoid manually handling the PIN itself.
// Then we are extracting the username that the user supplied during setup, so that we can add another unique element to the hash.
// From there, we mash the user name, the passed-in PIN hash, and the secret key (from ChristmasConstants.h) together to create
// one long, unique string.
// Then we send that entire hash mashup into the SHA256 method below to create a "Digital Digest," which is considered
// a one-way encryption algorithm. "One-way" means that it can never be reverse-engineered, only brute-force attacked.
// The algorthim we are using is Hash = SHA256(Name + Salt + (Hash(PIN))). This is called "Digest Authentication."
+ (NSString *)securedSHA256DigestHashForPIN:(NSUInteger)pinHash name:(NSString *)name salt:(NSString *)salt
{
    NSLog(@"\n............... SHA256 process start ....................");
    NSLog(@"Input Param : PinHash %lu", (unsigned long)pinHash);
    NSLog(@"Input Param : Salt %@, with length %lu", salt, (unsigned long)[salt length]);
    NSLog(@"Input Param : Name %@, with length %lu", name, (unsigned long)[name length]);
    
    if (salt.length == 0) {
        salt = SALT_HASH;
    }
    
    // To avoid any attempted attacks with special characters,
    name = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *computedHashString = [NSString stringWithFormat:@"%@%lu%@", name, (unsigned long)pinHash, salt];
    NSLog(@"Combination of hash: %@, with length %lu ", computedHashString, (unsigned long)[computedHashString length]);
    
    NSString *finalHash = [self computeSHA256DigestForString:computedHashString];
    NSLog(@"SHA256 Encrptyed hash: %@, with length %lu", finalHash, (unsigned long)[finalHash length]);
    NSLog(@"\n............... SHA256 process End ......................");
    return finalHash;
}

// This is where the rest of the magic happens.
// Here we are taking in our string hash, placing that inside of a C Char Array, then parsing it through the SHA256 encryption method.
+ (NSString*)computeSHA256DigestForString:(NSString*)input
{
    
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA256(data.bytes,(CC_LONG)data.length, digest);

    // Setup our Objective-C output.
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

#pragma mark - AES
#pragma mark -
#pragma mark Encryption

+ (NSData *)encryptDataAES256:(NSData *)data password:(NSString *)privateKey error:(NSError **)error {
    return [[self class] encryptData:data withSettings:kRNCryptorAES256Settings password:privateKey error:error];
}

+ (NSData *)encryptData:(NSData *)data withSettings:(RNCryptorSettings)settings password:(NSString *)privateKey error:(NSError **)error {
    NSData *encryptedData = [RNEncryptor encryptData:data withSettings:settings password:privateKey error:error];
    return encryptedData;
}


#pragma mark Decryption
+ (NSData *)decryptDataAES256:(NSData *)data password:(NSString *)privateKey error:(NSError **)error {
    return [[self class] decryptData:data withSettings:kRNCryptorAES256Settings password:privateKey error:error];
}

+ (NSData *)decryptData:(NSData *)data withSettings:(RNCryptorSettings)settings password:(NSString *)privateKey error:(NSError **)error {
    NSData *decryptedData = [RNDecryptor decryptData:data withSettings:settings password:privateKey error:error];
    return decryptedData;
}

#pragma mark -
+ (NSData *)encrypt:(NSData *)plainText key:(NSString *)key iv:(NSString *)iv {
    char keyPointer[kCCKeySizeAES256+2],// room for terminator (unused) ref: https://devforums.apple.com/message/876053#876053
    ivPointer[kCCBlockSizeAES128+2];
    bzero(keyPointer, sizeof(keyPointer)); // fill with zeroes for padding
    
    [key getCString:keyPointer maxLength:sizeof(keyPointer) encoding:NSUTF8StringEncoding];
    [iv getCString:ivPointer maxLength:sizeof(ivPointer) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [plainText length];
    //see https://developer.apple.com/library/ios/documentation/System/Conceptual/ManPages_iPhoneOS/man3/CCryptorCreateFromData.3cc.html
    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block.
    size_t buffSize = dataLength + kCCBlockSizeAES128;
    void *buff = malloc(buffSize);
    size_t numBytesEncrypted = 0;
    //refer to http://www.opensource.apple.com/source/CommonCrypto/CommonCrypto-36064/CommonCrypto/CommonCryptor.h
    //for details on this function
    //Stateless, one-shot encrypt or decrypt operation.
    CCCryptorStatus status = CCCrypt(kCCEncrypt, /* kCCEncrypt, etc. */
                                     kCCAlgorithmAES128, /* kCCAlgorithmAES128, etc. */
                                     kCCOptionPKCS7Padding, /* kCCOptionPKCS7Padding, etc. */
                                     keyPointer, kCCKeySizeAES256, /* key and its length */
                                     ivPointer, /* initialization vector - use random IV everytime */
                                     [plainText bytes], [plainText length], /* input */
                                     buff, buffSize,/* data RETURNED here */
                                     &numBytesEncrypted);
    if (status == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buff length:numBytesEncrypted];
    }
    free(buff);
    return nil;
}

+ (NSData *)decrypt:(NSData *)encryptedText key:(NSString *)key iv:(NSString *)iv {
    char keyPointer[kCCKeySizeAES256+2],// room for terminator (unused) ref: https://devforums.apple.com/message/876053#876053
    ivPointer[kCCBlockSizeAES128+2];
    
    [key getCString:keyPointer maxLength:sizeof(keyPointer) encoding:NSUTF8StringEncoding];
    [iv getCString:ivPointer maxLength:sizeof(ivPointer) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [encryptedText length];
    //see https://developer.apple.com/library/ios/documentation/System/Conceptual/ManPages_iPhoneOS/man3/CCryptorCreateFromData.3cc.html
    // For block ciphers, the output size will always be less than or equal to the input size plus the size of one block.
    size_t buffSize = dataLength + kCCBlockSizeAES128;
    void *buff = malloc(buffSize);
    size_t numBytesEncrypted = 0;
    //refer to http://www.opensource.apple.com/source/CommonCrypto/CommonCrypto-36064/CommonCrypto/CommonCryptor.h
    //for details on this function
    //Stateless, one-shot encrypt or decrypt operation.
    CCCryptorStatus status = CCCrypt(kCCDecrypt,/* kCCEncrypt, etc. */
                                     kCCAlgorithmAES128, /* kCCAlgorithmAES128, etc. */
                                     kCCOptionPKCS7Padding, /* kCCOptionPKCS7Padding, etc. */
                                     keyPointer, kCCKeySizeAES256,/* key and its length */
                                     ivPointer, /* initialization vector - use same IV which was used for decryption */
                                     [encryptedText bytes], [encryptedText length], //input
                                     buff, buffSize,//output
                                     &numBytesEncrypted);
    if (status == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buff length:numBytesEncrypted];
    }
    free(buff);
    return nil;
}

+ (NSString *)encryptPBEWithMD5AndDES:(NSString *)plainText withKey:(NSString*)encryptKey{
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    static Byte salt[] =
    {
        (unsigned char)0xB2, (unsigned char)0x12, (unsigned char)0xD5, (unsigned char)0xB2,
        (unsigned char)0x44, (unsigned char)0x21, (unsigned char)0xC3, (unsigned char)0xC3
    };
    
    NSData *dataSalt = [[NSData alloc] initWithBytes:salt length:8];
    
    unsigned char md5[CC_MD5_DIGEST_LENGTH];
    memset(md5, 0, CC_MD5_DIGEST_LENGTH);
    NSData* passwordData = [encryptKey dataUsingEncoding:NSUTF8StringEncoding];
    
    CC_MD5_CTX ctx;
    CC_MD5_Init(&ctx);
    CC_MD5_Update(&ctx, [passwordData bytes], (int)[passwordData length]);
    CC_MD5_Update(&ctx, [dataSalt bytes], (int)[dataSalt length]);
    CC_MD5_Final(md5, &ctx);
    
    for (int i=1; i<10; i++) {
        CC_MD5(md5, CC_MD5_DIGEST_LENGTH, md5);
    }
    
    size_t cryptoResultDataBufferSize = [data length] + kCCBlockSizeDES;
    unsigned char cryptoResultDataBuffer[cryptoResultDataBufferSize];
    size_t dataMoved = 0;
    
    unsigned char iv[kCCBlockSizeDES];
    memcpy(iv, md5 + (CC_MD5_DIGEST_LENGTH/2), sizeof(iv));
    
    CCCryptorStatus status =
    CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, md5, (CC_MD5_DIGEST_LENGTH/2), iv, [data bytes], [data length],
            cryptoResultDataBuffer, cryptoResultDataBufferSize, &dataMoved);
    
    if(0 == status) {
        return [self encode:[NSData dataWithBytes:cryptoResultDataBuffer length:dataMoved]];
    } else {
        return NULL;
    }
}

+ (NSString *)decryptPBEWithMD5AndDES:(NSString *)encryptedText withKey:(NSString *)decryptKey{
    NSData *data = [self decode:encryptedText];
    
    static Byte salt[] ={
        (unsigned char)0xB2, (unsigned char)0x12, (unsigned char)0xD5, (unsigned char)0xB2,
        (unsigned char)0x44, (unsigned char)0x21, (unsigned char)0xC3, (unsigned char)0xC3
    };
    
    NSData *dataSalt = [[NSData alloc] initWithBytes:salt length:8];
    
    unsigned char md5[CC_MD5_DIGEST_LENGTH];
    memset(md5, 0, CC_MD5_DIGEST_LENGTH);
    NSData* passwordData = [decryptKey dataUsingEncoding:NSUTF8StringEncoding];
    
    CC_MD5_CTX ctx;
    CC_MD5_Init(&ctx);
    CC_MD5_Update(&ctx, [passwordData bytes], (int)[passwordData length]);
    CC_MD5_Update(&ctx, [dataSalt bytes], (int)[dataSalt length]);
    CC_MD5_Final(md5, &ctx);
    
    for (int i=1; i<10; i++) {
        CC_MD5(md5, CC_MD5_DIGEST_LENGTH, md5);
    }
    
    size_t cryptoResultDataBufferSize = [data length] + kCCBlockSizeDES;
    unsigned char cryptoResultDataBuffer[cryptoResultDataBufferSize];
    size_t dataMoved = 0;
    
    unsigned char iv[kCCBlockSizeDES];
    memcpy(iv, md5 + (CC_MD5_DIGEST_LENGTH/2), sizeof(iv));
    
    CCCryptorStatus status =
    CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, md5, (CC_MD5_DIGEST_LENGTH/2), iv, [data bytes], [data length],
            cryptoResultDataBuffer, cryptoResultDataBufferSize, &dataMoved);
    
    if(0 == status) {
        return [[NSString alloc] initWithData:[NSData dataWithBytes:cryptoResultDataBuffer length:dataMoved] encoding:NSUTF8StringEncoding];
    } else {
        return NULL;
    }
}

+ (NSString*) SHA1:(NSString *) stringToSHA{
    NSData *myData = [stringToSHA dataUsingEncoding:NSASCIIStringEncoding];
    
    unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA1(myData.bytes, (unsigned int) myData.length, output);
    return [self encode:[NSMutableData dataWithBytes:output length:outputLength]];
}

+ (NSString*) SHA256:(NSString *) stringToSHA{
    NSData *myData = [stringToSHA dataUsingEncoding:NSASCIIStringEncoding];
    
    unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA256(myData.bytes, (unsigned int) myData.length, output);
    
    return [self encode:[NSMutableData dataWithBytes:output length:outputLength]];
}

+ (NSString *) Hmac:(NSString *) stringToHmac withKey: (NSString *) key{
    const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [stringToHmac cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [self encode:[NSMutableData dataWithBytes:cHMAC length:sizeof(cHMAC)]];
}

+ (NSString *) tripleDESEncrypt:(NSString *)stringToEncrypt withKey:(NSString *)encryptKey{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    plainTextBufferSize = [stringToEncrypt length];
    vplainText = (const void *) [stringToEncrypt UTF8String];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    uint8_t iv[kCCBlockSize3DES];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    NSString *key = encryptKey;
    const void *vkey = (const void *) [key UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding| kCCOptionECBMode,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       iv, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
    if(ccStatus == 0) {
        return [self encode:myData];
    }else{
        return NULL;
    }
}

+ (NSString *) tripleDESdecryption:(NSString *)stringToDecrypt withKey:(NSString *)decryptKey{
    NSData *preDecrypt = [self decode:stringToDecrypt];
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    plainTextBufferSize = [preDecrypt length];
    vplainText = [preDecrypt bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    uint8_t iv[kCCBlockSize3DES];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    NSString *key = decryptKey;
    const void *vkey = (const void *) [key UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding| kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       iv,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
    if(ccStatus == 0) {
        return [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    } else {
        return NULL;
    }
}

@end
