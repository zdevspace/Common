//
//  NSString+TextDirectionality.h
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * `GitTextDirection` indicates text directionality, such as Neutral, Left-to-Right, and Right-to-Left
 */
typedef NS_ENUM(NSUInteger, GitTextDirection) {
    /**
     * `GitTextDirectionNeutral` indicates text with no directionality
     */
    GitTextDirectionNeutral = 0,
    
    /**
     * `GitTextDirectionLeftToRight` indicates text left-to-right directionality
     */
    GitTextDirectionLeftToRight,
    
    /**
     * `GitTextDirectionRightToLeft` indicates text right-to-left directionality
     */
    GitTextDirectionRightToLeft,
};

/**
 * `NSString (TextDirectionality)` is an NSString category that is used to infer the text directionality of a string.
 */
@interface NSString (TextDirectionality)

/**
 *  Inspects the string and makes a best guess at text directionality.
 *
 *  @return the inferred text directionality of this string.
 */
- (GitTextDirection)getBaseDirection;

@end
