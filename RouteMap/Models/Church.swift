//
//  Church.swift
//  Church
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import MapKit

class Church: NSObject, MKAnnotation, Codable {
    let name: String
    let urlString: String
    public let coordinate: CLLocationCoordinate2D
    
    public var title: String? {
        return name
    }
    
    var url: URL {
        URL(string: urlString)!
    }
    
    public init(name: String, url: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.urlString = url
        self.coordinate = coordinate
    }
}
