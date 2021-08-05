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
    
    @Binding var centreCoordinate: CLLocationCoordinate2D
    
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
        mapView.addOverlays(routesVM.polylines)
    }
}
