//
//  Coordinate.swift
//  Coordinate
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import CoreLocation

struct Coordinate: Decodable {
    let lat: Double
    let long: Double
    
    var coord2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
