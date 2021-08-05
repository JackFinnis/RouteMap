//
//  RoutesVM.swift
//  RoutesVM
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import MapKit

class RoutesVM: NSObject, ObservableObject {
    // MARK: - Routes
    @Published var routes = [Route]()
    @Published var filteredRoutes = [Route]()
    @Published var selectedRoute: Route?
    @Published var loading: Bool = true
    
    public var filteredPolylines: [Polyline] {
        var polylines = [Polyline]()
        for route in filteredRoutes {
            polylines.append(route.polyline)
        }
        return polylines
    }
    
    // MARK: - Workout Filters
    @Published var sortBy: RoutesSortBy = .longest { didSet { updateRouteFilters() } }
    @Published var numberShown: RoutesShown = .all { didSet { updateRouteFilters() } }
    @Published var distanceFilter = RouteFilter(type: .distance) { didSet { updateRouteFilters() } }
    
    // MARK: - Initialiser
    override init() {
        super.init()
        // Load routes from the api
        loadRoutes()
    }
    
    // MARK: - Private Functions
    // Load routes from the api
    private func loadRoutes() {
        let url = URL(string: "https://ncct-api.finnisjack.repl.co/routes")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Route].self, from: data) {
                    DispatchQueue.main.async {
                        self.routes = response
                        self.updateRouteFilters()
                        self.loading = false
                    }
                    return
                }
            }
            print("\(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    
    // MARK: - Public Functions
    // Find the closest filtered route to the center coordinate
    public func setClosestRoute(center: CLLocationCoordinate2D) {
        let centerCoordinate = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        var minimumDistance: Double = .greatestFiniteMagnitude
        var closestRoute: Route?
        
        for route in filteredRoutes {
            for coord in route.coords {
                let delta = coord.coordCLL.distance(from: centerCoordinate)
                if delta < minimumDistance {
                    minimumDistance = delta
                    closestRoute = route
                }
            }
        }
        
        DispatchQueue.main.async {
            self.resetSelectedColour()
            self.selectedRoute = closestRoute
            self.setSelectedColour()
        }
    }
    
    var routesRegion: MKCoordinateRegion {
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
    
    // MARK: - Selected Route
    // Select the first filtered route to highlight
    public func selectFirstWorkout() {
        // Reset selected colour
        resetSelectedColour()
        selectedRoute = filteredRoutes.first
        setSelectedColour()
    }
    
    // Reset selected route polyline colour
    private func resetSelectedColour() {
        selectedRoute?.polyline.selected = false
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    // Set selected route polyline colour
    private func setSelectedColour() {
        selectedRoute?.polyline.selected = true
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    // Highlight next route
    public func nextRoute() {
        // Reset selected colour
        resetSelectedColour()
        if filteredRoutes.isEmpty {
            selectedRoute = nil
        } else if selectedRoute == nil {
            selectedRoute = filteredRoutes.first
        } else {
            let index = filteredRoutes.firstIndex(of: selectedRoute!)
            if index == nil {
                selectedRoute = filteredRoutes.first
            } else {
                if index == filteredRoutes.count-1 {
                    selectedRoute = filteredRoutes.first
                } else {
                    selectedRoute = filteredRoutes[index!+1]
                }
            }
        }
        setSelectedColour()
    }
    
    // Highlight previous route
    public func previousRoute() {
        // Reset selected colour
        resetSelectedColour()
        if filteredRoutes.isEmpty {
            selectedRoute = nil
        } else if selectedRoute == nil {
            selectedRoute = filteredRoutes.first
        } else {
            let index = filteredRoutes.firstIndex(of: selectedRoute!)
            if index == nil {
                selectedRoute = filteredRoutes.first
            } else {
                if index == 0 {
                    selectedRoute = filteredRoutes.last
                } else {
                    selectedRoute = filteredRoutes[index!-1]
                }
            }
        }
        setSelectedColour()
    }
    
    // MARK: - Filter Routes
    // Update route filters
    public func updateRouteFilters() {
        // Filter and sort routes
        let filtered = filterRoutes()
        let sorted = sortRoutes(routes: filtered)
        let numberFiltered = filterNumber(routes: sorted)
        
        // Update published
        DispatchQueue.main.async {
            self.filteredRoutes = numberFiltered
            self.selectFirstWorkout()
        }
    }
    
    // Filter routes
    private func filterRoutes() -> [Route] {
        // Filter routes
        routes.filter { route in
            // Filter by distance
//            if distanceFilter.filter {
//                if workout.distance <= distanceFilter.minimum {
//                    return false
//                }
//                if distanceFilter.minimum < distanceFilter.maximum && workout.distance >= distanceFilter.maximum {
//                    return false
//                }
//            }
            
            // Passed filter criteria!
            return true
        }
    }
    
    // Filter and sort all workouts based on previous properties
    private func sortRoutes(routes: [Route]) -> [Route] {
        // Sort workouts
        routes.sorted { (route1, route2) in
//            switch sortBy {
//            case .shortest:
//                if route1.date == nil || route2.date == nil {
//                    return false
//                }
//                return route1.date! > route2.date!
//            case .longest:
//                if route1.date == nil || route2.date == nil {
//                    return false
//                }
//                return route1.date! < route2.date!
//            }
            return route1.id < route2.id
        }
    }
    
    // Filter the number of routes
    private func filterNumber(routes: [Route]) -> [Route] {
        switch numberShown {
        case .none:
            return []
        case .five:
            if routes.count < 5 {
                return routes
            } else {
                return Array(routes[..<5])
            }
        case .ten:
            if routes.count < 10 {
                return routes
            } else {
                return Array(routes[..<10])
            }
        case .all:
            return routes
        }
    }
    
    // MARK: - String Formatting
    var selectedRouteDistanceString: String {
        if selectedRoute == nil {
            return ""
        } else {
            return selectedRoute!.colourString // selectedRoute!.distanceString
        }
    }
}
