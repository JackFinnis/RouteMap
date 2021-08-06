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

    func makeCoordinator() -> MapVM {
        mapVM.parent = self
        return mapVM
    }

    func makeUIView(context: Context) -> MKMapView {
        // Set delegate
        mapView.delegate = context.coordinator
        
        // Show user location, map scale and compass
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Pan to all routes
        if mapVM.loading != routesVM.loading {
            mapVM.loading = routesVM.loading
            let region = mapVM.getRegion(routes: routesVM.filteredRoutes)
            if region != nil {
                mapView.setRegion(region!, animated: true)
            }
            mapVM.userTrackingMode = .none
        }
        // Pan to route
        if mapVM.selectedRoute != routesVM.selectedRoute {
            mapVM.selectedRoute = routesVM.selectedRoute
            let region = mapVM.getRegion(routes: [routesVM.selectedRoute!])
            if region != nil {
                mapView.setRegion(region!, animated: true)
            }
            mapVM.userTrackingMode = .none
        }
        
        // Set user tracking mode
        if mapView.userTrackingMode != mapVM.userTrackingMode {
            mapView.setUserTrackingMode(mapVM.userTrackingMode, animated: true)
        }
        // Set map type
        if mapView.mapType != mapVM.mapType {
            mapView.mapType = mapVM.mapType
        }
        
        // Updated polyline overlays
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
