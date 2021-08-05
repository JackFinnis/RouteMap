//
//  FilterWorkouts.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI

struct FilterWorkouts: View {
    @EnvironmentObject var routesVM: RoutesVM
    @EnvironmentObject var mapVM: MapVM
    
    @Binding var showFilterWorkoutsSheet: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Routes Shown")) {
                    Picker("Number of Routes Shown", selection: $routesVM.numberShown.animation()) {
                        ForEach(RoutesShown.allCases, id: \.self) { number in
                            Text(getNumberString(numberString: number.rawValue))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if routesVM.numberShown != .none {
                        if routesVM.loading {
                            HStack {
                                ProgressView()
                                    .padding(.trailing, 1)
                                Text("Loading Routes...")
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                        
                        Picker("Sort By", selection: $routesVM.sortBy) {
                            ForEach(RoutesSortBy.allCases, id: \.self) { sortBy in
                                Text(sortBy.rawValue)
                            }
                        }
                    }
                }
                
                Section(header: Text("Advanced Filters")) {
                    NavigationLink(destination: DistanceFilterView()) {
                        HStack {
                            Text("Distance")
                            Spacer()
                            Text(routesVM.distanceFilter.summary)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Cycling Routes")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        showFilterWorkoutsSheet = false
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
    
    // Get number string for segmented picker
    func getNumberString(numberString: String) -> String {
        if numberString == "All" && !routesVM.loading {
            return "\(numberString) (\(routesVM.filteredRoutes.count))"
        } else {
            return numberString
        }
    }
}

