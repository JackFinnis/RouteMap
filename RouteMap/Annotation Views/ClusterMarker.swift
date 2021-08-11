//
//  ClusterMarker.swift
//  ClusterMarker
//
//  Created by William Finnis on 07/08/2021.
//

import Foundation
import MapKit

class ClusterMarker: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            if let cluster = newValue as? MKClusterAnnotation {
                let colour: UIColor = .systemOrange
//                let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24))
                
                markerTintColor = colour
                glyphText = String(cluster.memberAnnotations.count)
                displayPriority = .defaultHigh
                animatesWhenAdded = true
                
//                canShowCallout = true
//
//                let routeBtn = UIButton(type: .custom)
//                let routeImg = UIImage(systemName: "location.circle", withConfiguration: config)
//                routeBtn.setImage(routeImg, for: .normal)
//                routeBtn.tintColor = colour
//                routeBtn.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
//                routeBtn.addTarget(self, action: #selector(routeTo), for: .touchUpInside)
//                rightCalloutAccessoryView = routeBtn
            }
        }
    }
}
