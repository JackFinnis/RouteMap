//
//  Church.swift
//  Church
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import MapKit

struct Church: Decodable {
    let name: String
    let urlString: String
    let coord: Coordinate
    
    var url: URL {
        URL(string: urlString)!
    }
    
    var annotation: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.coordinate = coord.coord2D
        return annotation
    }
}
