//
//  ContentView.swift
//  RouteMap
//
//  Created by William Finnis on 04/08/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var routesVM = RoutesVM()
    
    var body: some View {
        List(routesVM.routes) { route in
            Text(route.colourString)
        }
        .task(routesVM.loadRoutes)
    }
}
