//
//  Route.swift
//  Route
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import MapKit
import UIKit

struct Route: Decodable, Identifiable {
    let id: Int
    let start: String
    let end: String
    let metres: Int
    let churches: [Church]
    let coords: [CLLocationCoordinate2D]
    
    var name: String {
        "\(id): " + start + " to " + end
    }
    
    var polyline: MKPolyline {
        return MKPolyline(coordinates: coords, count: coords.count)
    }
}

extension Route: Equatable {
    static func == (lhs: Route, rhs: Route) -> Bool {
        lhs.id == rhs.id
    }
}
