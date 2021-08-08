//
//  RootView.swift
//  RootView
//
//  Created by William Finnis on 05/08/2021.
//

import SwiftUI
import CoreLocation

struct RootView: View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                MapView()
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        MapSettings()
                    }
                    ControlBox()
                }
                .animation(vm.animation)
            }
            .navigationTitle("See on Map")
            .navigationBarHidden(true)
        }
        .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
        .environmentObject(vm)
    }
}
