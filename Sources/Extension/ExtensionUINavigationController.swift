//
//  ExtensionUINavigationController.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

open class ExtensionUINavigationController: NSObject {

}

/**
 UINavigationController extension - set startup bar color
 
 ### Usage Example: ###
 ```swift
 import GGITCommon
 ...
 
 UINavigationController.setStartupBarAndTintColor()
 ```
 */
extension UINavigationController{
    @objc open func setStartupBarAndTintColor(){
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
}
