//
//  GitMapLauncherMode.swift
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 26/11/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

import MapKit

public enum GitMapLauncherMode: String {
    case walking
    case bicycling
    case driving
    case transit
    case taxi
    
    /// Look up the transport mode identifier name for a given app.
    ///
    /// - Parameter app: navigation app
    /// - Returns: For Apple Maps a `[String:String]`, `String` for anything else. `nil` if
    ///            irrelevant.
    func identifier(for app: GitMapLauncherApp) -> Any? { // swiftlint:disable:this cyclomatic_complexity
        switch app {
        case .appleMaps:
            switch self {
            case .walking:
                return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            case .driving:
                return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            case .transit:
                return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit]
            case .taxi:
                // it is supported, but there's no key for this...
                return [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            default: return nil
            }
        case .googleMaps:
            switch self {
            case .walking: return "walking"
            case .bicycling: return "bicycling"
            case .driving: return "driving"
            case .transit: return "transit"
                // just like Apple Maps this actually is supported, but the key isn't specified in the
            // docs... meh.
            case .taxi: return "driving"
            }
        case .citymapper, .transit:
            return nil
        case .lyft, .uber:
            return nil
        case .navigon:
            return nil
        case .waze:
            return nil
        case .dbnavigator:
            return nil
        case .yandex:
            return nil
        case .moovit:
            return nil
        }
    }
}
