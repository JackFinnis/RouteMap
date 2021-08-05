//
//  Route.swift
//  Route
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import MapKit
import UIKit

struct Route: Decodable, Identifiable, Equatable {
    let id: Int
    let colourString: String
    let churches: [Church]
    let coords: [Coordinate]
    
    var colour: UIColor {
        UIColor(hex: colourString)!
    }
    
    var coords2D: [CLLocationCoordinate2D] {
        var coords2D = [CLLocationCoordinate2D]()
        for coord in coords {
            coords2D.append(coord.coord2D)
        }
        return coords2D
    }
    
    var polyline: Polyline {
        Polyline(coordinates: coords2D, count: coords2D.count)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        lhs.id == rhs.id
    }
}
