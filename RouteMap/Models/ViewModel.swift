//
//  RoutesVM.swift
//  RoutesVM
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import MapKit
import SwiftUI

class ViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    // Routes
    @Published var routes = [Route]()
    @Published var loading: Bool = true
    @Published var selectedRoute: Route? {
        didSet {
            if selectedRoute == nil {
                showRouteBar = false
            }
        }
    }
    
    // Route filters
    @Published var searchText: String = ""
    @Published var sortBy: SortBy = .id {
        didSet {
            selectFirstRoute()
        }
    }
    
    // Advanced filters
    @Published var filter: Bool = false
    @Published var showRoutes: Bool = true
    @Published var showChurches: Bool = true
    @Published var showVisited: Bool = true
    @Published var showUnvisited: Bool = true
    @Published var minimumDistance: Double = 0
    @Published var maximumDistance: Double = 0
    @Published var maximumProximity: Double = 0
    
    // View state
    @Published var showSearchBar: Bool = false
    @Published var showRouteBar: Bool = false
    @Published var focusOnSelected: Bool = false
    @Published var animation: Animation? = .none
    
    // Map settings
    @Published var mapType: MKMapType = .standard
    @Published var trackingMode: MKUserTrackingMode = .none
    @Published var userLocation = CLLocationCoordinate2D()
    @Published var locationManager = CLLocationManager()
    
    // Map history variables
    var mapLoading: Bool = true
    var mapSelectedRoute: Route?
    
    // MARK: - Initialiser
    override init() {
        super.init()
        setupLocationManager()
        loadRoutes()
    }
    
    // Setup location manager
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
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
//        var routes = [Route]()
//        if selectedRoute != nil && focusOnSelected {
//            routes = [selectedRoute!]
//        } else {
//            routes = self.routes
//        }
//
        let filteredRoutes = routes.filter { route in
            if filter {
                if !showRoutes { return false }
                if route.metres < Int(minimumDistance) * 1_000 { return false }
                if minimumDistance < maximumDistance && route.metres > Int(maximumDistance) * 1_000 { return false }
                if maximumProximity != 0 && distanceTo(route: route) > maximumProximity { return false }
            }
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
                return route1.density < route2.density
            }
        }
    }
    
    // All unfiltered churches
    public var churches: [Church] {
        var churches = [Church]()
        for route in routes {
            churches.append(contentsOf: route.churches)
        }
        return churches
    }
    
    // Filtered churches
    public var filteredChurches: [Church] {
        if filter && !showChurches {
            return []
        } else if selectedRoute != nil {
            return selectedRoute!.churches.filter { church in
                if searchText.isEmpty { return true }
                if church.name.localizedCaseInsensitiveContains(searchText) { return true }
                return false
            }
        } else {
            return churches.filter { church in
                if church.name.localizedCaseInsensitiveContains(searchText) { return true }
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
    
    // Get the distance between the user and route
    private func distanceTo(route: Route) -> Double {
        var minimum: Double = .greatestFiniteMagnitude
        var delta: Double = 0
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        delta = userCLLocation.distance(from: route.startCLL)
        if minimum > delta { minimum = delta }
        
        delta = userCLLocation.distance(from: route.endCLL)
        if minimum > delta { minimum = delta }
        
        for church in route.churches {
            delta = userCLLocation.distance(from: church.coordCLL)
            if minimum > delta { minimum = delta }
        }
        
        return minimum
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
        } else if selectedRoute != nil {
            routes = [selectedRoute!]
        } else {
            return nil
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
            return "No Filter"
        } else if showRoutes {
            return "Routes"
        } else if showChurches {
            return "Churches"
        } else {
            return "No Features"
        }
    }
    
    // Visited summary
    public var filterVisitedSummary: String {
        if showVisited && showUnvisited {
            return "No Filter"
        } else if showVisited {
            return "Visited"
        } else if showUnvisited {
            return "Unvisited"
        } else {
            return "No Features"
        }
    }
    
    // Separation summary
    public var filterProximitySummary: String {
        if maximumProximity == 0 {
            return "No Filter"
        } else {
            return "< \(Int(maximumProximity)) km away"
        }
    }
    
    // Distance summary
    public var filterDistanceSummary: String {
        if minimumDistance == 0 && maximumDistance == 0 {
            return "No Filter"
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
            return "globe"
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
    
    public var focusOnSelectedImage: String {
        if focusOnSelected {
            return "eye.fill"
        } else {
            return "eye"
        }
    }
    
    public var filterImage: String {
        if filter {
            return "line.horizontal.3.decrease.circle.fill"
        } else {
            return "line.horizontal.3.decrease.circle"
        }
    }
    
    public var showRouteBarImage: String {
        if showRouteBar {
            return "menubar.rectangle"
        } else {
            return "menubar.dock.rectangle"
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
}

// MARK: - CLLocationManager Delegate
extension ViewModel: CLLocationManagerDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.userLocation = userLocation.coordinate
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
                showRouteBar = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if !animated {
            trackingMode = .none
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        animation = .default
    }
}
