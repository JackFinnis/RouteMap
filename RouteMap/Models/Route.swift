//
//  Route.swift
//  Route
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import UIKit

struct Route: Decodable, Identifiable {
    let id: Int
    let colourString: String
    let churches: [Church]
    let coords: [Coordinate]
    
    var colour: UIColor {
        UIColor(hex: colourString)!
    }
}
