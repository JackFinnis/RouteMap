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
    let start: String
    let end: String
    let metres: Int
    let churches: [Church]
    let coords: [Coordinate]
    
    var name: String {
        "\(id): " + start + " to " + end
    }
    
    var coords2D: [CLLocationCoordinate2D] {
        var coords2D = [CLLocationCoordinate2D]()
        for coord in coords {
            coords2D.append(coord.coord2D)
        }
        return coords2D
    }
    
    var coordsCLL: [CLLocation] {
        var coordsCLL = [CLLocation]()
        for coord in coords {
            coordsCLL.append(coord.coordCLL)
        }
        return coordsCLL
    }
    
    var polyline: MKPolyline {
        MKPolyline(coordinates: coords2D, count: coords2D.count)
    }
    
    var churchAnnotations: [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for church in churches {
            annotations.append(church.annotation)
        }
        return annotations
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        lhs.id == rhs.id
    }
}
