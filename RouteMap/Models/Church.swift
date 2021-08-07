//
//  Church.swift
//  Church
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import MapKit

class Church: NSObject, MKAnnotation, Decodable {
    let name: String
    let url: URL?
    let coordinate: CLLocationCoordinate2D
    
    var title: String? {
        return name
    }
    
    init(name: String, url: URL, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.url = url
        self.coordinate = coordinate
    }
}
