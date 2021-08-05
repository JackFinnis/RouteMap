//
//  RouteFilter.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import Foundation

struct RouteFilter {
    var type: RouteFilterType
    var filter: Bool = false
    var maximum: Double = 0
    var minimum: Double = 0
    var summary: String {
        if !filter || (minimum == 0 && maximum == 0) {
            return ""
        } else if minimum >= maximum {
            return "> " + String(format: "%.1f ", minimum) + type.rawValue
        } else if minimum == 0 {
            return "< " + String(format: "%.1f ", maximum) + type.rawValue
        } else {
            return String(format: "%.1f", minimum) + "-" + String(format: "%.1f ", maximum) + type.rawValue
        }
    }
}
