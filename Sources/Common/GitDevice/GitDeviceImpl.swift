//
//  GitDeviceImpl.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 05/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit
import ExternalAccessory

extension GitDevice: GitDeviceStub {
    public static func getDeviceUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    public static func getDeviceModel() -> String {
        return UIDevice.current.model
    }
    
    public static func getDeviceLanguage() -> String? {
        return Locale.current.languageCode
    }
    
    public static func getDeviceName() -> String {
        return UIDevice.current.name
    }
    
    public static func getDeviceSystemName() -> String {
        return UIDevice.current.systemName
    }
    
    public static func getDeviceSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    public static func getDeviceHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    public static func getDeviceWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public static func isDeviceRooted() -> Bool {
        guard let cydiaUrlScheme = URL(string: "cydia://package/com.example.package") else{ return isJailBroken() }
        return UIApplication.shared.canOpenURL(cydiaUrlScheme) || isJailBroken()
    }
    
    static func isJailBroken() -> Bool{
        #if !(TARGET_IPHONE_SIMULATOR)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath:"/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            fileManager.fileExists(atPath:"/bin/bash") ||
            fileManager.fileExists(atPath:"/usr/sbin/sshd") ||
            fileManager.fileExists(atPath:"/etc/apt") ||
            fileManager.fileExists(atPath:"/usr/bin/ssh") {
            return true
        }
        
        if canOpen(path: "/Applications/Cydia.app") ||
            canOpen(path: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            canOpen(path: "/bin/bash") ||
            canOpen(path: "/usr/sbin/sshd") ||
            canOpen(path: "/etc/apt") ||
            canOpen(path: "/usr/bin/ssh") {
            return true
        }
        
        let path = "/private/" + NSUUID().uuidString
        do {
            try "anyString".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
        #else
        return false
        #endif
        
    }
    
    static func canOpen(path: String) -> Bool {
        let file = fopen(path, "r")
        guard file != nil else { return false }
        fclose(file)
        return true
    }
}

