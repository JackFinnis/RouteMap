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
                        Toggle("Show Routes", isOn: $vm.showRoutes)
                        Toggle("Show Churches", isOn: $vm.showChurches)
                    } label: {
                        HStack {
                            Text("Features Shown")
                            Spacer()
                            Text(vm.filterAnnotationsSummary)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section {
                    DisclosureGroup(isExpanded: $expandVisited) {
                        Toggle("Show Visited", isOn: $vm.showVisited)
                        Toggle("Show Unvisited", isOn: $vm.showUnvisited)
                    } label: {
                        HStack {
                            Text("Visited Features Shown")
                            Spacer()
                            Text(vm.filterVisitedSummary)
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
