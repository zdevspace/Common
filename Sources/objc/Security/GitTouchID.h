//
//  GitTouchID.h
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ErrorCode) {
    /// success
    TOUCHSUCCESS,
    /// failed
    TOUCHFAIL,
    /// cancel
    TOUCHCANCEL,
    /// fall back
    TOUCHFALLBACK,
    /// no passcode
    TOUCHNOPASSCODE,
    /// no touch id
    TOUCHNOTOUCHID,
    /// no ten rolled
    TOUCHNOTENROLLED,
    /// unknown
    TOUCHUNKNOWN,
    /// error
    TOUCHERROR
};

@interface GitTouchID : UIViewController
//@property (nonatomic, copy) void (^completionHandler)(NSString *);

/**
 *  Authenticate user with Touch ID
 *
 *  @param reasonString Description to display on Touch ID's prompt view
 *  @param allowFallback Boolean value on whether to allow users to input password screen
 *
 */
+(void)verifyTouchID :(NSString*) reasonString : (BOOL)allowFallback withCompletionHandler:(void (^)(ErrorCode status))handler;

@end
