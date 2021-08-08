//
//  FilterBar.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI

struct FilterBar: View {
    @EnvironmentObject var vm: ViewModel
    
    @State var showFilterView: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                vm.updateVisitedFilter()
            } label: {
                Image(systemName: vm.visitedFilterImage)
                    .font(.system(size: 23))
                    .frame(width: 46, height: 46)
            }
            Button {
                showFilterView.toggle()
            } label: {
                Image(systemName: vm.filterImage)
                    .font(.system(size: 23))
                    .frame(width: 46, height: 46)
            }
            Menu {
                Picker("Sort routes by: ", selection: $vm.sortBy) {
                    ForEach(SortBy.allCases, id: \.self) { sortBy in
                        Text(sortBy.rawValue)
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 23))
                    .frame(width: 46, height: 46)
            }
            
            Spacer()
            Button {
                withAnimation {
                    vm.showRouteBar.toggle()
                }
            } label: {
                Image(systemName: vm.showRouteBarImage)
                    .font(.system(size: 23))
                    .frame(width: 46, height: 46)
            }
            Button {
                withAnimation {
                    vm.showSearchBar.toggle()
                }
            } label: {
                Image(systemName: vm.showSearchBarImage)
                    .font(.system(size: 23))
                    .frame(width: 46, height: 46)
            }
        }
        .sheet(isPresented: $showFilterView) {
            FilterView(showFilterView: $showFilterView)
                .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
                .environmentObject(vm)
        }
    }
}
