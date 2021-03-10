//
//  FrameworkUtils.m
//  VRSM
//
//  Created by Kelvin Leong on 08/02/2018.
//  Copyright © 2018 Silverlake Mobility. All rights reserved.
//

#import "FrameworkUtils.h"
#import <UIKit/UIKit.h>

#define kBundleIdentifier @"com.ggit.mobilesdk.GGITCommon-iOS"

@implementation FrameworkUtils

+ (UIImage *) getImageFromFramework:(NSString*)imageName imageRenderMode: (UIImageRenderingMode) mode {
    return [[UIImage imageNamed:imageName inBundle:[FrameworkUtils getBundleFromFramework] compatibleWithTraitCollection:nil] imageWithRenderingMode:mode];

}

+ (UIStoryboard *) getStoryboardFromFramework:(NSString *)storyboardWithName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardWithName bundle:[FrameworkUtils getBundleFromFramework]];
//     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardWithName bundle:[NSBundle bundleWithIdentifier:kBundleIdentifier]];
    return storyboard;
}

+ (NSBundle *) getBundleFromFramework {
//    return [FrameworkUtils getBundleFromFramework];
     return [NSBundle bundleWithIdentifier:kBundleIdentifier];
}

@end
