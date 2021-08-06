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
                        return
                    }
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
    
    // Filtered church annotations
    var filteredChurchAnnotations: [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for route in filteredRoutes {
            annotations.append(contentsOf: route.churchAnnotations)
        }
        return annotations
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
}
