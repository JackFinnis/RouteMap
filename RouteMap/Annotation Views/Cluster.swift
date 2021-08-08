//
//  Cluster.swift
//  Cluster
//
//  Created by William Finnis on 07/08/2021.
//

import Foundation
import MapKit

class Cluster: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {
                markerTintColor = .systemOrange
                glyphText = String(cluster.memberAnnotations.count)
                displayPriority = .defaultHigh
                animatesWhenAdded = true
            }
        }
    }
}
