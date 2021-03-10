//
//  GitKeychain.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 05/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

open class GitKeychain {
    public enum GitKeychainConstants {
        static let accessible = kSecAttrAccessible as String
        static let accessGroup = kSecAttrAccessGroup as String
        static let account = kSecAttrAccount as String
        static let `class` = kSecClass as String
        static let matchLimit = kSecMatchLimit as String
        static let returnData = kSecReturnData as String
        static let returnAttributes = kSecReturnAttributes as String
        static let service = kSecAttrService as String
        static let valueData = kSecValueData as String
        
        static let genericPassword = kSecClassGenericPassword as String
        static let matchLimitOne = kSecMatchLimitOne as String
        static let matchLimitAll = kSecMatchLimitAll as String
        static let synchronizable = kSecAttrSynchronizable as String
    }
    
    static var defaultIdentifier: String = Bundle.main.infoDictionary?[kCFBundleIdentifierKey as String] as? String
        ?? "\(GitConstant.frameworkBundleID).service"
    public static var defaultService: String = defaultIdentifier
    public static var defaultAccessGroup: String? = nil
    
    public static let `default` = GitKeychain()
    
    let securityItemManager: GitSecurityItemManaging
    
    var lastQueryParameters: [String: Any]?
    /// Contains result code from the last operation. Value is noErr (0) for a successful result.
    open var lastResultCode: OSStatus = noErr
    
    var keyPrefix = "" // Can be useful in test.
    
    /**
     Specify an access group that will be used to access keychain items. Access groups can be used to share keychain items between applications. When access group value is nil all application access groups are being accessed. Access group name is used by all functions: set, get, delete and clear.
     */
    open var accessGroup: String?
    
    
    /**
     
     Specifies whether the items can be synchronized with other devices through iCloud. Setting this property to true will
     add the item to other devices with the `set` method and obtain synchronizable items with the `get` command. Deleting synchronizable items will remove them from all devices. In order for keychain synchronization to work the user must enable "Keychain" in iCloud settings.
     
     Does not work on macOS.
     
     */
    open var synchronizable: Bool = false
    
    let readLock = NSLock()
    
   
    init(keyPrefix: String, securityItemManager: GitSecurityItemManaging = GitSecurityItemManager.default) {
        self.keyPrefix = keyPrefix
        self.securityItemManager = GitSecurityItemManager.default
    }
    
    init(securityItemManager: GitSecurityItemManaging = GitSecurityItemManager.default) {
        self.securityItemManager = securityItemManager
    }
    
}

public protocol GitKeychainStub {
    //MARK: - Keychain
    @discardableResult
    func set(_ value: String, forKey key:String, withAccess access:GitKeychain.GitKeychainAccessOptions?) -> Bool
    @discardableResult
    func set(_ value:Bool, forKey key:String, withAccess access:GitKeychain.GitKeychainAccessOptions?) -> Bool
    @discardableResult
    func set(_ value:Data, forKey key:String, withAccess access:GitKeychain.GitKeychainAccessOptions?) -> Bool
    
    @discardableResult
    func get(key:String) -> String?
    @discardableResult
    func get(key:String) -> Bool?
    @discardableResult
    func get(key:String) -> Data?
    
    @discardableResult
    func delete(_ key:String) -> Bool
    @discardableResult
    func clear() -> Bool
    
    
    //MARK: - Codable
    static func configureDefaults(withService service: String, accessGroup: String?)
    static func resetDefaults()
    func store<T: GitKeychainCodable>(_ storable: T, service: String, accessGroup: String?) throws
    func retrieveValue<T: GitKeychainCodable>(forAccount account: String, service: String, accessGroup: String?) throws -> T?
    func retrieveAccounts(withService service: String, accessGroup: String?) throws -> [String]?
    func delete<T: GitKeychainCodable>(_ storable: T, service: String, accessGroup: String?) throws
    func clearAll(withService service: String, accessGroup: String?) throws
    
}
