//
//  GitMapLauncherLocation.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 26/11/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import CoreLocation

public struct GitMapLauncherLocation {
    public let coordinate: CLLocationCoordinate2D
    public let name: String?
    public let address: String?
    
    public init(name: String? = nil, address: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
    }
    
    public init(name: String? = nil,
                address: String? = nil,
                latitude: CLLocationDegrees,
                longitude: CLLocationDegrees) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.init(name: name, address: address, coordinate: coordinate)
    }
}
