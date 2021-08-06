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
    @Published var trackingMode: MKUserTrackingMode = .none
    @Published var mapType: MKMapType = .standard
    @Published var showChurchDetails: Bool = false
    
    private var locationManager = CLLocationManager()
    public var parent: MapView?
    public var selectedRoute: Route?
    public var selectedChurch: Church?
    public var loading: Bool = true
    
    // MARK: - Initialiser
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - CLLocationManager
    // Set up location manager to show user location
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Map Helper Functions
    // Get map region
    public func getRegion(routes: [Route]) -> MKCoordinateRegion? {
        if routes.isEmpty {
            return nil
        }
        
        var minLat: Double = 90
        var maxLat: Double = -90
        var minLong: Double = 180
        var maxLong: Double = -180
        
        for route in routes {
            for coord in route.coords {
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
        }
        
        let latDelta: Double = maxLat - minLat
        let longDelta: Double = maxLong - minLong
        let span = MKCoordinateSpan(latitudeDelta: latDelta * 1.4, longitudeDelta: longDelta * 1.4)
        let centre = CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLong + maxLong)/2)
        let region = MKCoordinateRegion(center: centre, span: span)
        return region
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
}

// MARK: - MKMapView Delegate
extension MapVM: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        var colour: UIColor {
            if selectedRoute?.polyline.pointCount == polyline.pointCount {
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let identifier = "Church"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            annotationView?.image =
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? MKPointAnnotation {
            if parent != nil {
                for route in parent!.routesVM.filteredRoutes {
                    for church in route.churches {
                        if annotation.title == church.name {
                            selectedChurch = church
                            showChurchDetails = true
                            return
                        }
                    }
                }
            }
        }
    }
}
