//
//  MapView.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @EnvironmentObject var routesVM: RoutesVM
    @EnvironmentObject var mapVM: MapVM
    
    var mapView = MKMapView()

    func makeCoordinator() -> RoutesVM {
        routesVM.parent = self
        return routesVM
    }

    func makeUIView(context: Context) -> MKMapView {
        // Set delegate
        mapView.delegate = context.coordinator
        
        // Show user location, map scale and compass
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        
        // Register annotations
        mapView.register(ChurchMarkerView.self, forAnnotationViewWithReuseIdentifier: "Church")
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Pan to all routes
        if mapVM.loading != routesVM.loading {
            mapVM.loading = routesVM.loading
            let region = routesVM.getRoutesRegion(all: true)
            if region != nil {
                mapView.setRegion(region!, animated: true)
            }
            mapVM.trackingMode = .none
        }
        // Pan to route
        if mapVM.selectedRoute != routesVM.selectedRoute {
            mapVM.selectedRoute = routesVM.selectedRoute
            let region = routesVM.getRoutesRegion(all: false)
            if region != nil {
                mapView.setRegion(region!, animated: true)
            }
            mapVM.trackingMode = .none
        }
        
        // Set user tracking mode
        if mapVM.userTrackingMode != mapVM.trackingMode {
            mapVM.userTrackingMode = mapVM.trackingMode
            mapView.setUserTrackingMode(mapVM.trackingMode, animated: true)
        } else if mapView.userTrackingMode.rawValue != mapVM.userTrackingMode.rawValue {
            if let userTrackingMode = MKUserTrackingMode(rawValue: mapView.userTrackingMode.rawValue) {
                mapVM.userTrackingMode = userTrackingMode
                mapVM.trackingMode = userTrackingMode
            }
        }
        
        // Set map type
        if mapView.mapType != mapVM.mapType {
            mapView.mapType = mapVM.mapType
        }
        
        // Update church annotation overlays
        mapView.removeAnnotations(mapView.annotations)
        // Add filtered workouts polylines
        if !routesVM.loading && routesVM.selectedRoute != nil {
            mapView.addAnnotations(routesVM.selectedRoute!.churches)
        }
        
        // Update route polyline overlays
        mapView.removeOverlays(mapView.overlays)
        // Add filtered workouts polylines
        if !routesVM.loading {
            if routesVM.selectedRoute != nil {
                mapView.addOverlay(routesVM.selectedRoute!.polyline)
            } else {
                mapView.addOverlays(routesVM.filteredPolylines)
            }
        }
    }
}
