//
//  GitMapLauncherLocationRepresentable.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 26/11/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import CoreLocation
import MapKit

public protocol GitMapLauncherLocationRepresentable {
    var latitude: Double { get }
    var longitude: Double { get }
    /// - Note: This property is not supported by all navigation apps.
    var name: String? { get }
    var address: String? { get }
}

extension GitMapLauncherLocationRepresentable {
    internal var mapItem: MKMapItem {
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.latitude,
                                                                       longitude: self.longitude),
                                    addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.name
        return mapItem
    }
    
    internal var coordString: String {
        return "\(self.latitude),\(self.longitude)"
    }
}

extension GitMapLauncherLocation: GitMapLauncherLocationRepresentable {
    public var latitude: Double {
        return self.coordinate.latitude
    }
    
    public var longitude: Double {
        return self.coordinate.longitude
    }
}

// MARK: CoreLocation helpers
extension CLLocation: GitMapLauncherLocationRepresentable {
    public var latitude: Double {
        return self.coordinate.latitude
    }
    
    public var longitude: Double {
        return self.coordinate.longitude
    }
    
    public var name: String? {
        return nil
    }
    
    public var address: String? {
        return nil
    }
}

extension CLLocationCoordinate2D: GitMapLauncherLocationRepresentable {
    public var name: String? {
        return nil
    }
    
    public var address: String? {
        return nil
    }
}
