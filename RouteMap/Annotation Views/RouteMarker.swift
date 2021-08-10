//
//  RouteMarker.swift
//  RouteMarker
//
//  Created by William Finnis on 07/08/2021.
//

import Foundation
import MapKit

class RouteMarker: MKMarkerAnnotationView {
    let vm: ViewModel
    
    override var annotation: MKAnnotation? {
        willSet {
            if let route = newValue as? Route {
                var colour: UIColor {
                    if vm.visited(route: route) {
                        return .systemIndigo
                    } else {
                        return .systemBlue
                    }
                }
                
                markerTintColor = colour
                glyphText = String(route.id)
                displayPriority = .defaultHigh
                animatesWhenAdded = true
                canShowCallout = true
                rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                clusteringIdentifier = "Cluster"
                
                let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24))
                
                let visitedBtn = UIButton(type: .custom)
                let visitedImg = UIImage(systemName: vm.visitedRouteImage(route: route), withConfiguration: config)
                visitedBtn.setImage(visitedImg, for: .normal)
                visitedBtn.tintColor = colour
                visitedBtn.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
                visitedBtn.addTarget(self, action: #selector(toggleVisitedRoute), for: .touchUpInside)
                leftCalloutAccessoryView = visitedBtn
                
                let infoBtn = UIButton(type: .custom)
                let infoImg = UIImage(systemName: "info.circle", withConfiguration: config)
                infoBtn.setImage(infoImg, for: .normal)
                infoBtn.tintColor = colour
                infoBtn.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
                infoBtn.addTarget(self, action: #selector(selectRoute), for: .touchUpInside)
                rightCalloutAccessoryView = infoBtn
            }
        }
    }
    
    init(vm: ViewModel, annotation: MKAnnotation?, reuseIdentifier: String?) {
        self.vm = vm
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func toggleVisitedRoute() {
        if let route = annotation as? Route {
            vm.toggleVisitedRoute(route: route)
        }
    }
    
    @objc func selectRoute() {
        if let route = annotation as? Route {
            vm.selectedRoute = route
        }
    }
}

