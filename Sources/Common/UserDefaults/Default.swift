//
//  Default.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import Foundation

public final class Default<Base> {
    let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol DefaultCompatible {
    associatedtype CompatibleType
    
    var df: CompatibleType { get }
}

public extension DefaultCompatible {
    var df: Default<Self> {
        return Default(self)
    }
}

extension UserDefaults: DefaultCompatible {}
