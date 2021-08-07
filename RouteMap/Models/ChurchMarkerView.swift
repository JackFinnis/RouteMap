//
//  ChurchMarkerView.swift
//  ChurchMarkerView
//
//  Created by William Finnis on 07/08/2021.
//

import Foundation
import MapKit

class ChurchMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            newValue.flatMap(configure(with:))
        }
    }
    
    func configure(with annotation: MKAnnotation) {
        markerTintColor = .systemGreen
        glyphImage = #imageLiteral(resourceName: "cross")
        canShowCallout = true
        
        //            let identifier = "Church"
        //            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        //
        //            if annotationView == nil {
        //                annotationView = Church(annotation: annotation, reuseIdentifier: identifier)
        //                annotationView?.canShowCallout = true
        //                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        //            } else {
        //                annotationView?.annotation = annotation
        //            }
        //
        //            return annotationView
    }
}
