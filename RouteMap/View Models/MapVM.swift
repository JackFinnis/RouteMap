//
//  MapVM.swift
//  MyMap
//
//  Created by Finnis on 06/06/2021.
//

import Foundation
import MapKit

class MapVM: NSObject, ObservableObject {
    // MARK: - Properties
    @Published var userTrackingMode: MKUserTrackingMode = .none
    @Published var mapType: MKMapType = .standard
    @Published var searchState: RoutesSearchState = .none
    
    var parent: MapView?
    var selectedWorkout: Route?
    
    // Display image names
    public var userTrackingModeImageName: String {
        switch userTrackingMode {
        case .none:
            return "location"
        case .follow:
            return "location.fill"
        default:
            return "location.north.line.fill"
        }
    }
    
    public var searchStateImageName: String {
        switch searchState {
        case .none:
            return "magnifyingglass"
        case .finding:
            return "mappin.and.ellipse"
        case .found:
            return "xmark"
        }
    }
    
    public var mapTypeImageName: String {
        switch mapType {
        case .standard:
            return "globe"
        default:
            return "map"
        }
    }
    
    // MARK: - Map Settings Update Methods
    // User tracking mode button pressed
    public func updateUserTrackingMode() {
        switch userTrackingMode {
        case .none:
            userTrackingMode = .follow
        case .follow:
            userTrackingMode = .followWithHeading
        default:
            userTrackingMode = .none
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
    
    // Get map region
    public func getSelectedWorkoutRegion() -> MKCoordinateRegion? {
        if selectedWorkout == nil {
            return nil
        } else if selectedWorkout!.coords.isEmpty {
            return nil
        }
        
        var minLat: Double = 90
        var maxLat: Double = -90
        var minLong: Double = 180
        var maxLong: Double = -180
        
        for coord in selectedWorkout!.coords {
            if coord.lat < minLat {
                minLat = coord.lat
            }
            if coord.lat > maxLat {
                maxLat = coord.lat
            }
            if coord.long < minLong {
                minLong = coord.long
            }
            if coord.long > maxLong {
                maxLong = coord.long
            }
        }
        
        let latDelta: Double = maxLat - minLat
        let longDelta: Double = maxLong - minLong
        let span = MKCoordinateSpan(latitudeDelta: latDelta * 1.4, longitudeDelta: longDelta * 1.4)
        let centre = CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLong + maxLong)/2)
        let region = MKCoordinateRegion(center: centre, span: span)
        return region
    }
}

// MARK: - MKMapView Delegate
extension MapVM: MKMapViewDelegate {
    // Render multicolour polyline overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? Polyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        // Set different colour if selected
        var colour: UIColor {
            if polyline.selected {
                return .systemOrange
            } else {
                return .systemBlue
            }
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = colour
        renderer.lineWidth = 2
        return renderer
    }
    
    // Update parent centre coordinate
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        DispatchQueue.main.async {
            self.parent?.centreCoordinate = mapView.centerCoordinate
        }
    }
}
