//
//  RootView.swift
//  RootView
//
//  Created by William Finnis on 05/08/2021.
//

import SwiftUI
import CoreLocation

struct RootView: View {
    // Responsible for loading routes
    @StateObject var routesVM = RoutesVM()
    // Responsible for map settings
    @StateObject var mapVM = MapVM()
    
    // Map centre coordinate
    @State var centreCoord = CLLocationCoordinate2D()
    
    var body: some View {
        ZStack {
            MapView(centreCoord: $centreCoord)
                .ignoresSafeArea()
            FindRoutePointer(centreCoord: $centreCoord)
            FloatingMapButtons(centreCoord: $centreCoord)
//            RouteInfoBar()
        }
        .environmentObject(routesVM)
        .environmentObject(mapVM)
        .preferredColorScheme(mapVM.mapType == .standard ? .none : .dark)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                mapVM.userTrackingMode = .follow
            }
        }
    }
}
