//
//  MapVM.swift
//  MyMap
//
//  Created by Finnis on 06/06/2021.
//

import Foundation
import MapKit

class MapVM: ObservableObject {
    // MARK: - Properties
    @Published var trackingMode: MKUserTrackingMode = .none
    @Published var mapType: MKMapType = .standard
    
    var userTrackingMode: MKUserTrackingMode = .none
    var selectedRoute: Route?
    var loading: Bool = true
    
    // MARK: - Map Settings Images
    // Display image names
    public var trackingModeImage: String {
        switch trackingMode {
        case .none:
            return "location"
        case .follow:
            return "location.fill"
        default:
            return "location.north.line.fill"
        }
    }
    
    public var mapTypeImage: String {
        switch mapType {
        case .standard:
            return "globe.europe.africa.fill"
        default:
            return "map"
        }
    }
    
    // MARK: - Initialiser
    init() {
        // Setup location manager
        CLLocationManager().requestWhenInUseAuthorization()
    }
    
    // MARK: - Update Map Settings
    // User tracking mode button pressed
    public func updateTrackingMode() {
        switch trackingMode {
        case .none:
            trackingMode = .follow
        case .follow:
            trackingMode = .followWithHeading
        default:
            trackingMode = .none
        }
    }
    
    // Map type button pressed
    public func updateMapType() {
        switch mapType {
        case .standard:
            mapType = .hybrid
        default:
            mapType = .standard
        }
    }
}
