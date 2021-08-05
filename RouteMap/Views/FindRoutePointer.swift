//
//  FindRoutePointer.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI
import CoreLocation

struct FindRoutePointer: View {
    @EnvironmentObject var routesVM: RoutesVM
    @EnvironmentObject var mapVM: MapVM
    
    @Binding var centreCoordinate: CLLocationCoordinate2D
    
    var body: some View {
        if mapVM.searchState == .finding {
            Button(action: {
                mapVM.userTrackingMode = .none
                mapVM.searchState = .found
                routesVM.setClosestRoute(center: centreCoordinate)
            }, label: {
                Image(systemName: "circle")
            })
            .buttonStyle(FloatingButtonStyle())
        }
    }
}
