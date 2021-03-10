//
//  UserDefaults+Codable.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import Foundation

extension Default where Base: UserDefaults {
    public func store<T: Codable>(_ value: T,
                                  forKey key: String,
                                  encoder: JSONEncoder = JSONEncoder()) {
        if let data: Data = try? encoder.encode(value) {
            (base as UserDefaults).set(data, forKey: key)
        }
    }
    
    public func fetch<T>(forKey key: String,
                         type: T.Type,
                         decoder: JSONDecoder = JSONDecoder()) -> T? where T: Decodable {
        if let data = (base as UserDefaults).data(forKey: key) {
            return try? decoder.decode(type, from: data) as T
        }
        
        return nil
    }
}
