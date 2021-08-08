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
    var coordinate: CLLocationCoordinate2D { coords[coords.count / 2] }
    
    var start2D: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: coords.first!.latitude, longitude: coords.first!.longitude) }
    var startCLL: CLLocation { CLLocation(latitude: coords.first!.latitude, longitude: coords.first!.longitude) }
    var endCLL: CLLocation { CLLocation(latitude: coords.last!.latitude, longitude: coords.last!.longitude) }
    var density: Double { Double(metres) / Double(churches.count) / 1_000 }
    
    var stage: String { "Route \(id)" }
    var name: String { start + " to " + end }
    
    var polyline: MKPolyline { MKPolyline(coordinates: coords, count: coords.count) }
    var mapItem: MKMapItem {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: start2D, addressDictionary: nil))
        item.name = start
        return item
    }
}
