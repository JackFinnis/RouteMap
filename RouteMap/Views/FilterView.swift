//
//  FilterView.swift
//  FilterView
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject var vm: ViewModel
    
    @Binding var showFilterView: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Annotations Showing")
                        Spacer()
                        Text(vm.filterAnnotationsSummary)
                    }
                    Toggle("Show Routes", isOn: $vm.showRoutes)
                    Toggle("Show Churches", isOn: $vm.showChurches)
                }
                
                Section {
                    HStack {
                        Text("Route Distance")
                        Spacer()
                        Text(vm.filterDistanceSummary)
                    }
                    
                    HStack {
                        Text("Minimum Distance")
                        Spacer()
                        Text("\(Int(vm.minimumDistance / 1_000)) km")
                    }
                    Slider(value: $vm.minimumDistance, in: 0...100_000, step: 1_000)
                    
                    HStack {
                        Text("Maximum Distance")
                        Spacer()
                        Text("\(Int(vm.maximumDistance / 1_000)) km")
                    }
                    Slider(value: $vm.maximumDistance, in: 0...100_000, step: 1_000)
                }
                
                Section {
                    HStack {
                        Text("Route Proximity")
                        Spacer()
                        Text(vm.filterProximitySummary)
                    }
                    Slider(value: $vm.maximumDistance, in: 0...100_000, step: 1_000)
                }
            }
            .navigationTitle("Advanced Filters")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        showFilterView = false
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
}
