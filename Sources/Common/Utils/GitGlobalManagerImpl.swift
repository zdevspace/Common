//
//  GitGlobalManagerImpl.swift
//  GGITCommon_iOS
//
//  Created by Kelvin Leong on 04/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

extension GitGlobalManager: GitGlobalManagerStub {
    public static func getAppVersion() -> String {
        return String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)
    }
    
    public static func getBundleId() -> String {
        return String(describing: Bundle.main.bundleIdentifier!)
    }
    
    public static func getDisplayName() -> String {
        return String(describing: Bundle.main.infoDictionary!["CFBundleName"]!)
    }
    
    public static func displayVersionInAppSetting(enviroment: GitEnviroment) {
        let defaults = UserDefaults.standard
        defaults.set("\(enviroment.rawValue).\(String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!))" , forKey: "versionNumbers")
        defaults.synchronize()
        
        
    }
    
    public static func trim(str: String?) -> String {
        guard let str = str else {
            return ""
        }
        return str
    }
    
    public static func showHUDInView(view:UIView, label:String, customView:UIImageView?){
//        let hud = GitProgressHUD.showAdded(to: view, animated: true)
//
//        hud.customView = customView
//        hud.mode = .indeterminate
//        hud.label.text = label
    }
    
    public static func hide(view:UIView){
//        GitProgressHUD.hide(for: view, animated: true)
    }
}
