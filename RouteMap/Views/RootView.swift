//
//  RootView.swift
//  RootView
//
//  Created by William Finnis on 05/08/2021.
//

import SwiftUI
import CoreLocation

struct RootView: View {
    @StateObject var routesVM = RoutesVM()
    @StateObject var mapVM = MapVM()
    
    var body: some View {
        NavigationView {
            ZStack {
                MapView()
                    .ignoresSafeArea()
                MapSettings()
                RouteBar()
            }
            .navigationTitle("Route Map")
            .navigationBarHidden(true)
        }
        .environmentObject(routesVM)
        .environmentObject(mapVM)
        .preferredColorScheme(mapVM.mapType == .standard ? .none : .dark)
    }
}
