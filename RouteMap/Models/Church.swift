//
//  Church.swift
//  Church
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation

struct Church: Decodable {
    let name: String
    let urlString: String
    let coord: Coordinate
    
    var url: URL {
        URL(string: urlString)!
    }
}
