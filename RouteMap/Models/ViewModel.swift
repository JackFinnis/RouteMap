//
//  RoutesVM.swift
//  RoutesVM
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import MapKit

class ViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    // Routes
    @Published var routes = [Route]()
    @Published var loading: Bool = true
    @Published var selectedRoute: Route?
    
    // Route filters
    @Published var sortBy: SortBy = .id
    @Published var searchText: String = ""
    @Published var visitedFilter: VisitedFilter = .none
    
    // Advanced filters
    @Published var filter: Bool = false
    @Published var showRoutes: Bool = true
    @Published var showChurches: Bool = true
    @Published var minimumDistance: Double = 0
    @Published var maximumDistance: Double = 0
    @Published var maximumProximity: Double = 0
    
    // View state
    @Published var showSearchBar: Bool = false
    @Published var showRouteBar: Bool = false
    
    // Map settings
    @Published var mapType: MKMapType = .standard
    @Published var trackingMode: MKUserTrackingMode = .none
    
    // Map history variables
    var parent: MapView?
    var mapLoading: Bool = true
    var mapSelectedRoute: Route?
    
    // MARK: - Initialiser
    override init() {
        super.init()
        // Setup location manager
        CLLocationManager().requestWhenInUseAuthorization()
        // Load routes
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
        let filteredRoutes = routes.filter { route in
            if searchText.isEmpty { return true }
            if route.start.localizedCaseInsensitiveContains(searchText) { return true }
            if route.end.localizedCaseInsensitiveContains(searchText) { return true }
            if String(route.id).localizedCaseInsensitiveContains(searchText) { return true }
            for church in route.churches {
                if filteredChurches.contains(church) { return true }
            }
            return false
        }
        return filteredRoutes.sorted { (route1, route2) in
            switch sortBy {
            case .id:
                return route1.id < route2.id
            case .shortest:
                return route1.metres < route2.metres
            case .longest:
                return route1.metres > route2.metres
            case .churchDensity:
                return route1.density > route2.density
            }
        }
    }
    
    public var filteredChurches: [Church] {
        var churches = [Church]()
        for route in routes {
            for church in route.churches {
                if church.name.localizedCaseInsensitiveContains(searchText) {
                    churches.append(church)
                }
            }
        }
        return churches
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
    // Select first route
    public func selectFirstRoute() {
        selectedRoute = filteredRoutes.first
        showRouteBar = true
    }
    
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
    
    // MARK: - Filter Summaries
    // Annotation summary
    public var filterAnnotationsSummary: String {
        if showRoutes && showChurches {
            return ""
        } else if showRoutes {
            return "Routes"
        } else if showChurches {
            return "Churches"
        } else {
            return "No Annotations"
        }
    }
    
    // Separation summary
    public var filterProximitySummary: String {
        if maximumProximity == 0 {
            return ""
        } else {
            return "< \(Int(maximumDistance)) km away"
        }
    }
    
    // Distance summary
    public var filterDistanceSummary: String {
        if minimumDistance == 0 && maximumDistance == 0 {
            return ""
        } else if minimumDistance >= maximumDistance {
            return "> \(Int(minimumDistance)) km"
        } else if minimumDistance == 0 {
            return "< \(Int(maximumDistance)) km"
        } else {
            return "\(Int(minimumDistance))-\(Int(maximumDistance)) km"
        }
    }
    
    // MARK: - Images Names
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
    
    public var showSearchBarImage: String {
        if showSearchBar {
            return "minus.magnifyingglass"
        } else {
            return "plus.magnifyingglass"
        }
    }
    
    public var filterImage: String {
        if filter {
            return "line.3.horizontal.decrease.circle.fill"
        } else {
            return "line.3.horizontal.decrease.circle"
        }
    }
    
    public var showRouteBarImage: String {
        if showRouteBar {
            return "menubar.rectangle"
        } else {
            return "menubar.dock.rectangle"
        }
    }
    
    public var visitedFilterImage: String {
        switch visitedFilter {
        case .none:
            return "star"
        case .visited:
            return "star.fill"
        case .unvisited:
            return "star.slash.fill"
        }
    }
    
    // MARK: - Update Functions
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
    
    // Visited filter pressed
    public func updateVisitedFilter() {
        switch visitedFilter {
        case .none:
            visitedFilter = .visited
        case .visited:
            visitedFilter = .unvisited
        case .unvisited:
            visitedFilter = .none
        }
    }
}

// MARK: - MKMapView Delegate
extension ViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        // equatable?
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
            return ChurchMarker(annotation: annotation, reuseIdentifier: "Church")
        case is Route:
            return RouteMarker(annotation: annotation, reuseIdentifier: "Route")
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let view = view as? ChurchMarker {
            if let annotation = view.annotation as? Church {
                UIApplication.shared.open(annotation.url)
            }
        } else if let view = view as? RouteMarker {
            if let annotation = view.annotation as? Route {
                selectedRoute = annotation
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if !animated {
            trackingMode = .none
        }
    }
}