//
//  LocationMarker.swift
//  LocationMarker
//
//  Created by William Finnis on 10/08/2021.
//

import Foundation
import MapKit

class LocationMarker: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            markerTintColor = .systemPurple
            glyphImage = UIImage(systemName: "tram.fill")
            displayPriority = .defaultHigh
            animatesWhenAdded = true
            canShowCallout = true
            clusteringIdentifier = "Cluster"
            
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24))
            
            let routeBtn = UIButton(type: .custom)
            let routeImg = UIImage(systemName: "location.circle", withConfiguration: config)
            routeBtn.setImage(routeImg, for: .normal)
            routeBtn.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
            routeBtn.addTarget(self, action: #selector(routeTo), for: .touchUpInside)
            rightCalloutAccessoryView = routeBtn
        }
    }
    
    @objc func routeTo() {
        if let location = annotation as? Location {
            location.mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
        }
    }
}
