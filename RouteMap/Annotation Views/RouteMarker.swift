//
//  RouteMarker.swift
//  RouteMarker
//
//  Created by William Finnis on 07/08/2021.
//

import Foundation
import MapKit

class RouteMarker: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            if let route = newValue as? Route {
                markerTintColor = .systemBlue
                glyphText = String(route.id)
                displayPriority = .defaultHigh
                animatesWhenAdded = true
                canShowCallout = true
                rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                clusteringIdentifier = "Cluster"
            }
        }
    }
}

