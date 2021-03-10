//
//  GitDevice.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 05/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

public class GitDevice {

    public init() {
        Static.instance = self
    }
    
    struct Static {
        static var instance:GitDevice?
    }
    
    public class var sharedInstance : GitDevice {
        return Static.instance == nil ? GitDevice() : Static.instance!
    }
}

public protocol GitDeviceStub {
    //MARK: - Device Info
    static func getDeviceUUID() -> String
    static func getDeviceModel() -> String
    static func getDeviceLanguage() -> String?
    static func getDeviceName() -> String 
    static func getDeviceSystemName() -> String
    static func getDeviceSystemVersion() -> String
    static func getDeviceHeight() -> CGFloat
    static func getDeviceWidth() -> CGFloat
    static func isDeviceRooted() -> Bool
    
}
