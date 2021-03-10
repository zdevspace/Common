//
//  GitSecurityItemManaging.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 05/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import Foundation

protocol GitSecurityItemManaging {
    
    func add(withAttributes attributes: [String: Any], result: UnsafeMutablePointer<CoreFoundation.CFTypeRef?>?) -> OSStatus
    func update(withQuery query: [String: Any], attributesToUpdate: [String: Any]) -> OSStatus
    func delete(withQuery query: [String: Any]) -> OSStatus
    func copyMatching(_ query: [String: Any], result: UnsafeMutablePointer<CoreFoundation.CFTypeRef?>?) -> OSStatus
    
}

public class GitSecurityItemManager {
    public static let `default` = GitSecurityItemManager()
}

extension GitSecurityItemManager: GitSecurityItemManaging {
    
    public func add(withAttributes attributes: [String: Any], result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
        return SecItemAdd(attributes as CFDictionary, result)
    }
    
    public func update(withQuery query: [String: Any], attributesToUpdate: [String: Any]) -> OSStatus {
        return SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
    }
    
    public func delete(withQuery query: [String : Any]) -> OSStatus {
        return SecItemDelete(query as CFDictionary)
    }
    
    public func copyMatching(_ query: [String : Any], result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
        return SecItemCopyMatching(query as CFDictionary, result)
    }
    
}
