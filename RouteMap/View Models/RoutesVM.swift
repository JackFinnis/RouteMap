//
//  RoutesVM.swift
//  RoutesVM
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import CoreLocation
import MapKit

class RoutesVM: NSObject, ObservableObject {
    // MARK: - Routes
    @Published var routes = [Route]()
    @Published var filteredRoutes = [Route]()
    @Published var selectedRoute: Route?
    @Published var loading: Bool = true
    
    // MARK: - Workout Filters
    @Published var sortBy: RoutesSortBy = .longest // { didSet { updateWorkoutFilters() } }
    @Published var numberShown: RoutesShown = .all // { didSet { updateWorkoutFilters() } }
    @Published var distanceFilter = RouteFilter(type: .distance) { didSet { print(distanceFilter.summary) } }
    
    var polylines: [Polyline] {
        var polylines = [Polyline]()
        for route in routes {
            polylines.append(route.polyline)
        }
        return polylines
    }
    
    // MARK: - Initialiser
    override init() {
        super.init()
        // Load routes from the api
        loadRoutes()
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
//            self.resetSelectedColour()
            self.selectedRoute = closestRoute
//            self.setSelectedColour()
        }
    }
    
    // Return the filtered workouts multi polyline
    public func getFilteredRoutesPolylines() -> [Polyline] {
        return polylines
//        var polylines: [Polyline] = []
//
//        for route in filteredRoutes {
//            polylines.append(route.polyline)
//        }
//
//        return polylines
    }
    
    func getRoutesRegion() -> MKCoordinateRegion {
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
    
    // MARK: - Selected Workout
    // Reset selected workout polyline colour
    private func resetSelectedColour() {
        selectedRoute?.polyline.selected = false
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    // Set selected workout polyline colour
    private func setSelectedColour() {
        selectedRoute?.polyline.selected = true
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    // Highlight next workout
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
    
    // Highlight previous workout
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
    
    // MARK: - Private Functions
    // Load routes from the api
    func loadRoutes() {
        let url = URL(string: "https://ncct-api.finnisjack.repl.co/routes")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Route].self, from: data) {
                    DispatchQueue.main.async {
                        self.routes = response
                        self.loading = false
                    }
                }
            }
            print("\(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    // MARK: - String Formatting
    var selectedWorkoutDistanceString: String {
        if selectedRoute == nil {
            return ""
        } else {
            return selectedRoute!.colourString // selectedRoute!.distanceString
        }
    }
}
