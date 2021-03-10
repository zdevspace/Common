//
//  FrameworkUtils.h
//  VRSM
//
//  Created by Kelvin Leong on 08/02/2018.
//  Copyright © 2018 Silverlake Mobility. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FrameworkUtils : NSObject

+ (UIImage *) getImageFromFramework:(NSString*)imageName imageRenderMode: (UIImageRenderingMode) mode;
+ (UIStoryboard *) getStoryboardFromFramework:(NSString *)storyboardWithName;
+ (NSBundle *) getBundleFromFramework;
@end
