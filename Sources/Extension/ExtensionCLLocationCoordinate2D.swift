//
//  ExtensionCLLocationCoordinate2D.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    public func coordinateFrom(coord: CLLocationCoordinate2D, distanceKM: Double, bearingDegrees: Double) -> CLLocationCoordinate2D {
        
        let distanceRadians: Double = distanceKM / 6371.0 // 6,371 = Earth's radius in KM
        let bearingRadians: Double = bearingDegrees.degreesToRadians
        let fromLatRadians: Double = coord.latitude.degreesToRadians
        let fromLonRadians: Double = coord.longitude.degreesToRadians
        
        let toLatRadians: Double = asin(sin(fromLatRadians) * cos(distanceRadians) + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians))
        var toLonRadians: Double = fromLonRadians + atan2(sin(bearingRadians) * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians) - sin(fromLatRadians) * sin(toLatRadians))
        
        toLonRadians = fmod((toLonRadians + 3 * .pi), (2 * .pi)) - .pi
        
        return CLLocationCoordinate2D(latitude: toLatRadians.radiansToDegrees, longitude: toLonRadians.radiansToDegrees)
    }
}
