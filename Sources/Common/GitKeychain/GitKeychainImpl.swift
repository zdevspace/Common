//
//  GitKeychainImpl.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 05/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import UIKit

extension GitKeychain {
    public enum GitKeychainAccessOptions: RawRepresentable {
        private enum GitKeychainConstants {
            static let afterFirstUnlock = kSecAttrAccessibleAfterFirstUnlock as String
            static let afterFirstUnlockThisDeviceOnly = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String
            static let always = kSecAttrAccessibleAlways as String
            static let alwaysThisDeviceOnly = kSecAttrAccessibleAlwaysThisDeviceOnly as String
            static let whenPasscodeSetThisDeviceOnly = kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly as String
            static let whenUnlocked = kSecAttrAccessibleWhenUnlocked as String
            static let whenUnlockedThisDeviceOnly = kSecAttrAccessibleWhenUnlockedThisDeviceOnly as String
            static let synchronizable = kSecAttrSynchronizable as String
        }
        
        /**
         The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
         After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute migrate to a new device when using encrypted backups.
         */
        case afterFirstUnlock
        /**
         The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
         After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
         */
        case afterFirstUnlockThisDeviceOnly
        /**
         The data in the keychain item can always be accessed regardless of whether the device is locked.
         This is not recommended for application use. Items with this attribute migrate to a new device when using encrypted backups.
         */
        case always
        /**
         The data in the keychain item can always be accessed regardless of whether the device is locked.
         This is not recommended for application use. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
         */
        case alwaysThisDeviceOnly
        /**
         The data in the keychain can only be accessed when the device is unlocked. Only available if a passcode is set on the device.
         This is recommended for items that only need to be accessible while the application is in the foreground. Items with this attribute never migrate to a new device. After a backup is restored to a new device, these items are missing. No items can be stored in this class on devices without a passcode. Disabling the device passcode causes all items in this class to be deleted.
         */
        case whenPasscodeSetThisDeviceOnly
        /**
         The data in the keychain item can be accessed only while the device is unlocked by the user.
         This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute migrate to a new device when using encrypted backups.
         This is the default value for keychain items added without explicitly setting an accessibility constant.
         */
        case whenUnlocked
        /**
         The data in the keychain item can be accessed only while the device is unlocked by the user.
         This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
         */
        case whenUnlockedThisDeviceOnly
        
        public var rawValue: String {
            switch self {
            case .afterFirstUnlock:
                return GitKeychainConstants.afterFirstUnlock
            case .afterFirstUnlockThisDeviceOnly:
                return GitKeychainConstants.afterFirstUnlockThisDeviceOnly
            case .always:
                return GitKeychainConstants.always
            case .alwaysThisDeviceOnly:
                return GitKeychainConstants.alwaysThisDeviceOnly
            case .whenPasscodeSetThisDeviceOnly:
                return GitKeychainConstants.whenPasscodeSetThisDeviceOnly
            case .whenUnlocked:
                return GitKeychainConstants.whenUnlocked
            case .whenUnlockedThisDeviceOnly:
                return GitKeychainConstants.whenUnlockedThisDeviceOnly
            }
        }
        
        public init?(rawValue: String) {
            switch rawValue {
            case GitKeychainConstants.afterFirstUnlock:
                self = .afterFirstUnlock
            case GitKeychainConstants.afterFirstUnlockThisDeviceOnly:
                self = .afterFirstUnlockThisDeviceOnly
            case GitKeychainConstants.always:
                self = .always
            case GitKeychainConstants.alwaysThisDeviceOnly:
                self = .alwaysThisDeviceOnly
            case GitKeychainConstants.whenPasscodeSetThisDeviceOnly:
                self = .whenPasscodeSetThisDeviceOnly
            case GitKeychainConstants.whenUnlocked:
                self = .whenUnlocked
            case GitKeychainConstants.whenUnlockedThisDeviceOnly:
                self = .whenUnlockedThisDeviceOnly
            default:
                self = .whenUnlocked
            }
        }
    }
}

extension GitKeychain: GitKeychainStub {
    public func set(_ value: String, forKey key: String, withAccess access: GitKeychainAccessOptions?) -> Bool {
        guard let value = value.data(using: String.Encoding.utf8) else {
            return false
        }
        return set(value, forKey: key, withAccess: access)
    }
    
    /**
     Stores the boolean value in the keychain item under the given key.
     - parameter key: Key under which the value is stored in the keychain.
     - parameter value: Boolean to be written to the keychain.
     - parameter withAccess: Value that indicates when your app needs access to the value in the keychain item. By default the .AccessibleWhenUnlocked option is used that permits the data to be accessed only while the device is unlocked by the user.
     - returns: True if the value was successfully written to the keychain.
     */
    public func set(_ value: Bool, forKey key: String, withAccess access: GitKeychainAccessOptions?) -> Bool {
        let bytes: [UInt8] = value ? [1] : [0]
        let data = Data(_: bytes)
        
        return set(data, forKey: key, withAccess: access)
    }
    
    /**
     
     Stores the data in the keychain item under the given key.
     
     - parameter key: Key under which the data is stored in the keychain.
     - parameter value: Data to be written to the keychain.
     - parameter withAccess: Value that indicates when your app needs access to the text in the keychain item. By default the .AccessibleWhenUnlocked option is used that permits the data to be accessed only while the device is unlocked by the user.
     
     - returns: True if the text was successfully written to the keychain.
     
     */
    public func set(_ value: Data, forKey key: String, withAccess access: GitKeychainAccessOptions?) -> Bool {
        _ = delete(key) // Delete any existing key before saving it
        let accessible = access?.rawValue ?? GitKeychainAccessOptions.whenUnlocked.rawValue
        
        let prefixedKey = keyWithPrefix(key)
        
        var query: [String : Any] = [
            GitKeychainConstants.class      : kSecClassGenericPassword,
            GitKeychainConstants.account    : prefixedKey,
            GitKeychainConstants.valueData   : value,
            GitKeychainConstants.accessible  : accessible
        ]
        
        query = addAccessGroupWhenPresent(query)
        query = addSynchronizableIfRequired(query, addingItems: true)
        lastQueryParameters = query
        
        lastResultCode = SecItemAdd(query as CFDictionary, nil)
        
        return lastResultCode == noErr
    }
    
    /**
     
     Retrieves the text value from the keychain that corresponds to the given key.
     
     - parameter key: The key that is used to read the keychain item.
     - returns: The text value from the keychain. Returns nil if unable to read the item.
     
     */
    public func get(key: String) -> String? {
        if let data:Data = get(key: key) {
            
            if let currentString = String(data: data, encoding: .utf8) {
                return currentString
            }
            
            lastResultCode = -67853 // errSecInvalidEncoding
        }
        
        return nil
    }
    
    /**
     Retrieves the boolean value from the keychain that corresponds to the given key.
     - parameter key: The key that is used to read the keychain item.
     - returns: The boolean value from the keychain. Returns nil if unable to read the item.
     */
    public func get(key: String) -> Bool? {
        guard let data:Data = get(key: key) else { return nil }
        guard let firstBit = data.first else { return nil }
        return firstBit == 1
    }
    
    /**
     
     Retrieves the data from the keychain that corresponds to the given key.
     
     - parameter key: The key that is used to read the keychain item.
     - returns: The text value from the keychain. Returns nil if unable to read the item.
     
     */
    public func get(key: String) -> Data? {
        // The lock prevents the code to be run simlultaneously
        // from multiple threads which may result in crashing
        readLock.lock()
        defer { readLock.unlock() }
        
        let prefixedKey = keyWithPrefix(key)
        
        var query: [String: Any] = [
            GitKeychainConstants.class       : kSecClassGenericPassword,
            GitKeychainConstants.account : prefixedKey,
            GitKeychainConstants.returnData  : kCFBooleanTrue ?? false,
            GitKeychainConstants.matchLimit  : kSecMatchLimitOne
        ]
        
        query = addAccessGroupWhenPresent(query)
        query = addSynchronizableIfRequired(query, addingItems: false)
        lastQueryParameters = query
        
        var result: AnyObject?
        
        lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if lastResultCode == noErr { return result as? Data }
        
        return nil
    }
    
    /**
     Deletes the single keychain item specified by the key.
     
     - parameter key: The key that is used to delete the keychain item.
     - returns: True if the item was successfully deleted.
     
     */
    public func delete(_ key: String) -> Bool {
        let prefixedKey = keyWithPrefix(key)
        
        var query: [String: Any] = [
            GitKeychainConstants.class      : kSecClassGenericPassword,
            GitKeychainConstants.account    : prefixedKey
        ]
        
        query = addAccessGroupWhenPresent(query)
        query = addSynchronizableIfRequired(query, addingItems: false)
        lastQueryParameters = query
        
        lastResultCode = SecItemDelete(query as CFDictionary)
        
        return lastResultCode == noErr
    }
    
    /**
     Deletes all Keychain items used by the app. Note that this method deletes all items regardless of the prefix settings used for initializing the class.
     
     - returns: True if the keychain items were successfully deleted.
     
     */
    public func clear() -> Bool {
        var query: [String: Any] = [ kSecClass as String : kSecClassGenericPassword ]
        query = addAccessGroupWhenPresent(query)
        query = addSynchronizableIfRequired(query, addingItems: false)
        lastQueryParameters = query
        
        lastResultCode = SecItemDelete(query as CFDictionary)
        
        return lastResultCode == noErr
    }
    
    
    //MARK: - Private Functions
    /// Returns the key with currently set prefix.
    private func keyWithPrefix(_ key: String) -> String {
        return "\(keyPrefix)\(key)"
    }
    
    private func addAccessGroupWhenPresent(_ items: [String: Any]) -> [String: Any] {
        guard let accessGroup = accessGroup else { return items }
        
        var result: [String: Any] = items
        result[GitKeychainConstants.accessGroup] = accessGroup
        return result
    }
    
    /**
     
     Adds kSecAttrSynchronizable: kSecAttrSynchronizableAny` item to the dictionary when the `synchronizable` property is true.
     
     - parameter items: The dictionary where the kSecAttrSynchronizable items will be added when requested.
     - parameter addingItems: Use `true` when the dictionary will be used with `SecItemAdd` method (adding a keychain item). For getting and deleting items, use `false`.
     
     - returns: the dictionary with kSecAttrSynchronizable item added if it was requested. Otherwise, it returns the original dictionary.
     
     */
    private func addSynchronizableIfRequired(_ items: [String: Any], addingItems: Bool) -> [String: Any] {
        if !synchronizable { return items }
        var result: [String: Any] = items
        result[GitKeychainConstants.synchronizable] = addingItems == true ? true : kSecAttrSynchronizableAny
        return result
    }
    
    //MARK: - Codable
    public static func configureDefaults(withService service: String = defaultService, accessGroup: String? = defaultAccessGroup) {
        defaultService = service
        defaultAccessGroup = accessGroup
    }
    
    public static func resetDefaults() {
        defaultService = defaultIdentifier
        defaultAccessGroup = nil
    }
    
    public func store<T: GitKeychainCodable>(_ storable: T, service: String = defaultService, accessGroup: String? = defaultAccessGroup) throws {
        let newData = try JSONEncoder().encode(storable)
        var query = self.query(for: storable, service: service, accessGroup: accessGroup)
        let existingData = try data(forAccount: storable.account, service: service, accessGroup: accessGroup)
        var status = noErr
        let newAttributes: [String: Any] = [GitKeychainConstants.valueData: newData, GitKeychainConstants.accessible: storable.accessible.rawValue]
        if existingData != nil {
            status = securityItemManager.update(withQuery: query, attributesToUpdate: newAttributes)
        } else {
            query.merge(newAttributes) { $1 }
            status = securityItemManager.add(withAttributes: query, result: nil)
        }
        if let error = error(fromStatus: status) {
            throw error
        }
    }
    
    public func retrieveValue<T: GitKeychainCodable>(forAccount account: String, service: String = defaultService,
                                                   accessGroup: String? = defaultAccessGroup) throws -> T? {
        guard let data = try data(forAccount: account, service: service, accessGroup: accessGroup) else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    public func retrieveAccounts(withService service: String = defaultService, accessGroup: String? = defaultAccessGroup) throws -> [String]? {
        var query = self.query(forAccount: nil, service: service, accessGroup: accessGroup)
        query[GitKeychainConstants.matchLimit] = GitKeychainConstants.matchLimitAll
        query[GitKeychainConstants.returnAttributes] = kCFBooleanTrue
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            securityItemManager.copyMatching(query, result: UnsafeMutablePointer($0))
        }
        if let error = error(fromStatus: status), error != .itemNotFound { throw error }
        guard let attributes = result as? [[String: Any]] else { return nil }
        return attributes.compactMap { $0[GitKeychainConstants.account] as? String }
    }
    
    public func delete<T: GitKeychainCodable>(_ storable: T, service: String = defaultService, accessGroup: String? = defaultAccessGroup) throws {
        let query = self.query(forAccount: storable.account, service: service, accessGroup: accessGroup)
        let status = securityItemManager.delete(withQuery: query)
        if let error = error(fromStatus: status) { throw error }
    }
    
    public func clearAll(withService service: String = defaultService, accessGroup: String? = defaultAccessGroup) throws {
        guard let retrievedAccounts = try retrieveAccounts(withService: service, accessGroup: accessGroup) else { return }
        try retrievedAccounts.forEach {
            let query = self.query(forAccount: $0, service: service, accessGroup: accessGroup)
            try delete(withQuery: query)
        }
    }
    
    // MARK: - Convenience
    func delete(withQuery query: [String: Any]) throws {
        let status = securityItemManager.delete(withQuery: query)
        if let error = error(fromStatus: status) { throw error }
    }
    
    // MARK: - Query
    func query(forAccount account: String?, service: String, accessGroup: String?) -> [String: Any] {
        var query: [String: Any] = [
            GitKeychainConstants.service: service,
            GitKeychainConstants.class: GitKeychainConstants.genericPassword
        ]
        if let account = account {
            query[GitKeychainConstants.account] = account
        }
        if let accessGroup = accessGroup {
            query[GitKeychainConstants.accessGroup] = accessGroup
        }
        return query
    }
    
    func query(for storable: GitKeychainCodable, service: String, accessGroup: String?) -> [String: Any] {
        var query = self.query(forAccount: storable.account, service: service, accessGroup: accessGroup)
        query[GitKeychainConstants.accessible] = storable.accessible.rawValue
        return query
    }
    
    // MARK: - Data
    func data(forAccount account: String, service: String, accessGroup: String?) throws -> Data? {
        var query = self.query(forAccount: account, service: service, accessGroup: accessGroup)
        query[GitKeychainConstants.matchLimit] = GitKeychainConstants.matchLimitOne
        query[GitKeychainConstants.returnData] = kCFBooleanTrue
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            securityItemManager.copyMatching(query, result: UnsafeMutablePointer($0))
        }
        if let error = error(fromStatus: status), error != .itemNotFound { throw error }
        return result as? Data
    }
    
    // MARK: - Error
    func error(fromStatus status: OSStatus) -> GitKeychainError? {
        guard status != noErr && status != errSecSuccess else { return nil }
        return GitKeychainError(rawValue: Int(status)) ?? .unknown
    }
}
