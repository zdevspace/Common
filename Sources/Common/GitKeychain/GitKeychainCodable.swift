//
//  GitKeychainCodable.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 05/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import Foundation

public protocol GitKeychainCodable: Codable {
    
    var account: String { get }
    var accessible: GitKeychain.GitKeychainAccessOptions { get }
    
}

public extension GitKeychainCodable {
    
    var accessible: GitKeychain.GitKeychainAccessOptions { return .whenUnlocked }
    
}
