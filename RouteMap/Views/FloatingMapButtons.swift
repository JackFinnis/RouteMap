//
//  FloatingMapButtons.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI
import CoreLocation

struct FloatingMapButtons: View {
    @EnvironmentObject var routesVM: RoutesVM
    @EnvironmentObject var mapVM: MapVM
    
    @Binding var centreCoord: CLLocationCoordinate2D
    
    @State var showFilterWorkoutsSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    Button {
                        mapVM.updateMapType()
                    } label: {
                        Image(systemName: mapVM.mapTypeImageName)
                            .frame(width: 40, height: 40)
                    }
                    .padding(3)
                    
                    Divider()
                        .frame(width: 46)
                    Button {
                        mapVM.updateUserTrackingMode()
                    } label: {
                        Image(systemName: mapVM.userTrackingModeImageName)
                            .frame(width: 40, height: 40)
                    }
                    .padding(3)
                    
                    Divider()
                        .frame(width: 46)
                    Button {
                        showFilterWorkoutsSheet = true
                    } label: {
                        Image(systemName: "figure.walk")
                            .frame(width: 40, height: 40)
                    }
                    .padding(3)
                    
                    Divider()
                        .frame(width: 46)
                    Button {
                        updateSearchState()
                    } label: {
                        Image(systemName: mapVM.searchStateImageName)
                            .frame(width: 40, height: 40)
                    }
                    .padding(3)
                }
                .background(Blur())
                .cornerRadius(12)
                .compositingGroup()
                .shadow(radius: 2, y: 2)
                .padding(.trailing, 10)
                .padding(.top, 50)
            }
            Spacer()
        }
        .sheet(isPresented: $showFilterWorkoutsSheet) {
            FilterWorkouts(showFilterWorkoutsSheet: $showFilterWorkoutsSheet)
                .environmentObject(routesVM)
                .preferredColorScheme(mapVM.mapType == .standard ? .none : .dark)
        }
    }
    
    // Workout search button pressed
    func updateSearchState() {
        mapVM.userTrackingMode = .none
        switch mapVM.searchState {
        case .none:
            mapVM.searchState = .finding
        case .finding:
            mapVM.searchState = .found
            routesVM.setClosestRoute(center: centreCoord)
        case .found:
            mapVM.searchState = .none
        }
    }
}
