//
//  GitGlobalManager.swift
//  GGITCommon_iOS
//
//  Created by Kelvin Leong on 04/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

public enum GitEnviroment: String {
    /// this is sit get method
    case dev = "d"
    /// this is prod post method
    case prod = "v"
    /// this is uat put method
    case uat = "u"
}

public class GitGlobalManager {
    required init() {
        Static.instance = self
    }
    
    struct Static {
        static var instance:GitGlobalManager?
    }
    
    public class var sharedInstance : GitGlobalManager {
        return Static.instance == nil ? GitGlobalManager() : Static.instance!
    }
}

public protocol GitGlobalManagerStub {
    static func getAppVersion() -> String
    static func getDisplayName() -> String
    static func displayVersionInAppSetting(enviroment:GitEnviroment)
    static func trim(str:String?) -> String
    static func showHUDInView(view:UIView, label:String, customView:UIImageView?)
    static func hide(view:UIView)
}
