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
    let urlString: String
    let coordinate: CLLocationCoordinate2D
    
    var url: URL { URL(string: urlString)! }
    var title: String? { name }
    var subtitle: String? { "Church" }
}
