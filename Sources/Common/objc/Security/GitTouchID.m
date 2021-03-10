//
//  GitTouchID.m
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

#import "GitTouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface GitTouchID ()

@end

@implementation GitTouchID

+(void)verifyTouchID :(NSString*) reasonString : (BOOL)allowFallback withCompletionHandler:(void (^)(ErrorCode status))handler
{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    
    if(!allowFallback)
        myContext.localizedFallbackTitle = @"";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:reasonString
                            reply:^(BOOL success, NSError *error) {
                                
                                if (success) {
                                    // Authentication Success
                                    handler(TOUCHSUCCESS);
                                } else {
                                    // User did not authenticate successfully, look at error and take appropriate action
                                    switch (error.code) {
                                        case LAErrorAuthenticationFailed:
                                        {
                                            
                                            // Authentication Failed
                                            handler(TOUCHFAIL);
                                            break;
                                        }
                                        case LAErrorUserCancel:
                                        {
                                            // Clicked Cancel
                                            handler(TOUCHCANCEL);
                                            break;
                                        }
                                        case LAErrorUserFallback:
                                        {
                                            // Clicked Fallback to password
                                            handler(TOUCHFALLBACK);
                                            break;
                                        }
                                            
                                        case LAErrorPasscodeNotSet:
                                        {
                                            // Passcode not set for device
                                            handler(TOUCHNOPASSCODE);
                                            break;
                                        }
                                            
                                        case LAErrorTouchIDNotAvailable:
                                        {
                                            // Touch ID not available on device
                                            handler(TOUCHNOTOUCHID);
                                            break;
                                        }
                                          
                                        case LAErrorTouchIDNotEnrolled:
                                        {
                                            // Touch ID not enrolled on device
                                            handler(TOUCHNOTENROLLED);
                                            break;
                                        }
                                            
                                        default:
                                        {
                                            // Unknown error
                                            handler(TOUCHUNKNOWN);
                                            break;
                                        }
                                    }
                                }
        }];
    }
    else {
        // Unknown error
        handler(TOUCHERROR);
    }
}
@end
