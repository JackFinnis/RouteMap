//
//  FilterView.swift
//  FilterView
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject var vm: ViewModel
    
    @State var expandAnnotations: Bool = false
    @State var expandVisited: Bool = false
    @State var expandDistance: Bool = false
    @State var expandProximity: Bool = false
    
    @Binding var showFilterView: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DisclosureGroup(isExpanded: $expandAnnotations) {
                        Toggle("Hide Routes", isOn: $vm.hideRoutes)
                        Toggle("Hide Churches", isOn: $vm.hideChurches)
                    } label: {
                        HStack {
                            Text("Annotations Showing")
                            Spacer()
                            Text(vm.filterAnnotationsSummary)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section {
                    DisclosureGroup(isExpanded: $expandVisited) {
                        Toggle("Hide Visited", isOn: $vm.hideVisited)
                        Toggle("Hide Unvisited", isOn: $vm.hideUnvisited)
                    } label: {
                        HStack {
                            Text("Visited Routes")
                            Spacer()
                            Text(vm.filterAnnotationsSummary)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section {
                    DisclosureGroup(isExpanded: $expandDistance) {
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
                    } label: {
                        HStack {
                            Text("Route Distance")
                            Spacer()
                            Text(vm.filterDistanceSummary)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section {
                    DisclosureGroup(isExpanded: $expandProximity) {
                        Slider(value: $vm.maximumProximity, in: 0...100, step: 5, label: {
                            Text("Maximum Proximity")
                        }, minimumValueLabel: {
                            Text("Maximum")
                        }, maximumValueLabel: {
                            Text("")
                        })
                    } label: {
                        HStack {
                            Text("Route Proximity")
                            Spacer()
                            Text(vm.filterProximitySummary)
                                .foregroundColor(.secondary)
                        }
                    }
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
