//
//  Route.swift
//  Route
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import MapKit
import UIKit

class Route: NSObject, MKAnnotation, Decodable, Identifiable {
    let id: Int
    let start: String
    let end: String
    let metres: Int
    let churches: [Church]
    let coords: [CLLocationCoordinate2D]
    
    var title: String? { name }
    var subtitle: String? { stage }
    var coordinate: CLLocationCoordinate2D {
        coords[coords.count / 2]
    }
    
    var stage: String {
        "Stage \(id)"
    }
    
    var name: String {
        start + " to " + end
    }
    
    var density: Double {
        Double(churches.count) / Double(metres)
    }
    
    var polyline: MKPolyline {
        MKPolyline(coordinates: coords, count: coords.count)
    }
}
