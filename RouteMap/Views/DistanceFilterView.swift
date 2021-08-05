//
//  DistanceFilter.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct DistanceFilterView: View {
    @EnvironmentObject var routesVM: RoutesVM
    
    var body: some View {
        Form {
            Section {
                Toggle("Filter by Distance", isOn: $routesVM.distanceFilter.filter)
                if routesVM.distanceFilter.filter {
                    HStack {
                        Text("Minimum Distance")
                        Spacer()
                        Text("\(routesVM.distanceFilter.minimum, specifier: "%.1f") km")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $routesVM.distanceFilter.minimum, in: 0...10, step: 0.5)
                    
                    HStack {
                        Text("Maximum Distance")
                        Spacer()
                        Text("\(routesVM.distanceFilter.maximum, specifier: "%.1f") km")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $routesVM.distanceFilter.maximum, in: 0...10, step: 0.5)
                }
            }
        }
        .navigationTitle(routesVM.distanceFilter.summary)
    }
}
