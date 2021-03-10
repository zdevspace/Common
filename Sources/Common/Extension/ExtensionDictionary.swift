//
//  ExtensionDictionary.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 14/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import Foundation

extension Dictionary {
    /**
     Dictionary extension - convert dictionary to json
     
     ### Usage Example: ###
     ```swift
     import GGITCommon
     ...
     
     Dictionary.json
     ```
     */
    public var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    public func getKeys() -> [String]{
        var keys = [String?](repeating: nil, count:self.count)
        
        for (key, value) in self{
            keys[value as! Int] = key as? String
        }
        
        return keys as! [String]
    }
    
    mutating func merge<K, V>(dictionaries: Dictionary<K, V>...) {
        for dict in dictionaries {
            for (key, value) in dict {
                self.updateValue(value as! Value, forKey: key as! Key)
            }
        }
    }
}

extension NSDictionary {
    //    var data:Data? {
    //        guard let data = try? PropertyListSerialization.data(fromPropertyList: self, format: PropertyListSerialization.PropertyListFormat.binary, options: 0) else {return nil}
    //
    //        return data
    //    }
    
    public var data: Data? {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return jsonData
        } catch {
            return nil
        }
    }
}
