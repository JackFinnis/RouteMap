//
//  RoutesVM.swift
//  RoutesVM
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import MapKit

class RoutesVM: NSObject, ObservableObject {
    // MARK: - Properties
    @Published var routes = [Route]()
    @Published var loading: Bool = true
    @Published var selectedRoute: Route?
    @Published var searchText: String = ""
    
    public var parent: MapView?
    
    // MARK: - Initialiser
    override init() {
        super.init()
        loadRoutes()
    }
    
    // MARK: - Load Routes
    // Load routes from the api
    private func loadRoutes() {
        let url = URL(string: "https://ncct.finnisjack.repl.co/routes")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Route].self, from: data) {
                    DispatchQueue.main.async {
                        self.routes = response
                        self.loading = false
                    }
                    return
                }
            }
            print("\(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    // MARK: - Filter Routes
    // Filtered Routes
    public var filteredRoutes: [Route] {
        if searchText.isEmpty {
            return routes
        } else {
            return routes.filter { route in
                if route.start.localizedCaseInsensitiveContains(searchText) { return true }
                if route.end.localizedCaseInsensitiveContains(searchText) { return true }
                if String(route.id).localizedCaseInsensitiveContains(searchText) { return true }
                for church in route.churches {
                    if church.name.localizedCaseInsensitiveContains(searchText) { return true }
                }
                return false
            }
        }
    }
    
    // Filtered route polylines
    public var filteredPolylines: [MKPolyline] {
        var polylines = [MKPolyline]()
        for route in filteredRoutes {
            polylines.append(route.polyline)
        }
        return polylines
    }
    
    // MARK: - Select Route
    // Select next route
    public func nextRoute() {
        let index = getSelectedRouteIndex()
        if index != nil {
            if index! == filteredRoutes.count-1 {
                selectedRoute = filteredRoutes.first
            } else {
                selectedRoute = filteredRoutes[index!+1]
            }
        }
    }
    
    // Select previous route
    public func previousRoute() {
        let index = getSelectedRouteIndex()
        if index != nil {
            if index! == 0 {
                selectedRoute = filteredRoutes.last
            } else {
                selectedRoute = filteredRoutes[index!-1]
            }
        }
    }
    
    // Get the index of the current selected route
    private func getSelectedRouteIndex() -> Int? {
        if filteredRoutes.isEmpty {
            selectedRoute = nil
        } else if selectedRoute == nil {
            selectedRoute = filteredRoutes.first
        } else {
            let index = filteredRoutes.firstIndex(of: selectedRoute!)
            if index == nil {
                selectedRoute = filteredRoutes.first
            } else {
                return index
            }
        }
        return nil
    }
    
    // MARK: - Map Helper Functions
    // Get map region
    public func getRoutesRegion(all: Bool) -> MKCoordinateRegion? {
        var routes = [Route]()
        if all {
            routes = filteredRoutes
        } else {
            routes = [selectedRoute!]
        }
        
        guard !routes.isEmpty else {
            return nil
        }
        
        var minLat: Double = 90
        var maxLat: Double = -90
        var minLong: Double = 180
        var maxLong: Double = -180
        
        for route in routes {
            for coord in route.coords {
                if coord.latitude < minLat {
                    minLat = coord.latitude
                }
                if coord.latitude > maxLat {
                    maxLat = coord.latitude
                }
                if coord.longitude < minLong {
                    minLong = coord.longitude
                }
                if coord.longitude > maxLong {
                    maxLong = coord.longitude
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
}

// MARK: - MKMapView Delegate
extension RoutesVM: MKMapViewDelegate {
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
        switch annotation {
        case is Church:
            return mapView.dequeueReusableAnnotationView(withIdentifier: "Church", for: annotation)
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? MKPointAnnotation {
            if parent != nil {
                for route in parent!.routesVM.filteredRoutes {
                    for church in route.churches {
                        if annotation.title == church.name {
                            return
                        }
                    }
                }
            }
        }
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        self.objectWillChange.send()
    }
}
