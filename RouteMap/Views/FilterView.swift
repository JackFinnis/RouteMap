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
                Section(header: Text("Annotations")) {
                    HStack {
                        Text("Annotations Showing")
                        Spacer()
                        Text(vm.filterAnnotationsSummary)
                            .foregroundColor(.secondary)
                    }
                    Toggle("Hide Routes", isOn: $vm.hideRoutes)
                    Toggle("Hide Churches", isOn: $vm.hideChurches)
                }
                
                Section(header: Text("Visited")) {
                    HStack {
                        Text("Visited Routes")
                        Spacer()
                        Text(vm.filterAnnotationsSummary)
                            .foregroundColor(.secondary)
                    }
                    Toggle("Hide Visited", isOn: $vm.hideVisited)
                    Toggle("Hide Unvisited", isOn: $vm.hideUnvisited)
                }
                
                Section(header: Text("Distance")) {
                    HStack {
                        Text("Route Distance")
                        Spacer()
                        Text(vm.filterDistanceSummary)
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $vm.minimumDistance, in: 0...100, step: 5, label: {
                        Text("Minimum Distance")
                    }, minimumValueLabel: {
                        Text("Minimum")
                    }, maximumValueLabel: {
                        Text("")
                    })
                    Slider(value: $vm.maximumDistance, in: 0...100, step: 5, label: {
                        Text("Maximum Distance")
                    }, minimumValueLabel: {
                        Text("Maximum")
                    }, maximumValueLabel: {
                        Text("")
                    })
                }
                
                Section(header: Text("Proximity")) {
                    HStack {
                        Text("Route Proximity")
                        Spacer()
                        Text(vm.filterProximitySummary)
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $vm.maximumProximity, in: 0...100, step: 5, label: {
                        Text("Maximum Proximity")
                    }, minimumValueLabel: {
                        Text("Maximum")
                    }, maximumValueLabel: {
                        Text("")
                    })
                }
            }
            .navigationTitle("Advanced Filters")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showFilterView = false
                    } label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Toggle("Filter", isOn: $vm.filter)
                }
            }
        }
    }
}
