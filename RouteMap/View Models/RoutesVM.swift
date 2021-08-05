//
//  RoutesVM.swift
//  RoutesVM
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation
import CoreLocation

@MainActor
class RoutesVM: ObservableObject {
    // MARK: - Routes
    @Published var routes = [Route]()
    @Published var filteredRoutes = [Route]()
    @Published var selectedRoute: Route?
    @Published var loading: Bool = false
    
    var polylines: [Polyline] {
        var polylines = [Polyline]()
        for route in routes {
            polylines.append(route.polyline)
        }
        return polylines
    }
    
    // MARK: - Initialiser
    init() {
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
            self.resetSelectedColour()
            self.selectedRoute = closestRoute
            self.setSelectedColour()
        }
    }
    
    // Load routes from the api
    func loadRoutes() {
        let url = URL(string: "https://ncct-api.finnisjack.repl.co/routes.json")!
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
}
