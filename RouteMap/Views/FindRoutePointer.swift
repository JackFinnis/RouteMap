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
    
    @Binding var centreCoord: CLLocationCoordinate2D
    
    var body: some View {
        if mapVM.searchState == .finding {
            Button {
                mapVM.userTrackingMode = .none
                mapVM.searchState = .found
                routesVM.setClosestRoute(center: centreCoord)
            } label: {
                Image(systemName: "circle")
                    .frame(width: 40, height: 40)
            }
        }
    }
}