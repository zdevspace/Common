//
//  ExtensionEncodable.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 14/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import Foundation

extension Encodable {
    
    /**
     Encodable extension - convert object to dictionary
     
     ### Usage Example: ###
     ```swift
     import GGITCommon
     ...
     
     Encodable.dictionary
     ```
     */
    public var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}

extension Decodable {
    public static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}
