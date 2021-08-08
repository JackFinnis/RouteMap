//
//  ChurchMarker.swift
//  ChurchMarker
//
//  Created by William Finnis on 07/08/2021.
//

import Foundation
import MapKit

class ChurchMarker: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            markerTintColor = .systemGreen
            glyphImage = #imageLiteral(resourceName: "cross")
            displayPriority = .defaultHigh
            animatesWhenAdded = true
            canShowCallout = true
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            clusteringIdentifier = "Cluster"
        }
    }
}
