//
//  ActionBar.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI

struct ActionBar: View {
    @EnvironmentObject var vm: ViewModel
    
    @State var showFilterView: Bool = false
    @State var showInfoView: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                showInfoView = true
            } label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 24))
                    .frame(width: 48, height: 48)
            }
            Button {
                showFilterView.toggle()
            } label: {
                Image(systemName: vm.filterImage)
                    .font(.system(size: 24))
                    .frame(width: 48, height: 48)
            }
            Menu {
                ForEach(SortBy.allCases, id: \.self) { sortBy in
                    Button {
                        vm.sortBy = sortBy
                    } label: {
                        Text(sortBy.rawValue)
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 24))
                    .frame(width: 48, height: 48)
            }
            
            Spacer()
            if vm.loading {
                ProgressView()
                    .font(.system(size: 24))
                    .frame(width: 48, height: 48)
            }
            
            Button {
                withAnimation {
                    vm.showRouteBar.toggle()
                }
            } label: {
                Image(systemName: vm.showRouteBarImage)
                    .font(.system(size: 24))
                    .frame(width: 48, height: 48)
            }
            Button {
                withAnimation {
                    vm.showSearchBar.toggle()
                }
            } label: {
                Image(systemName: vm.showSearchBarImage)
                    .font(.system(size: 24))
                    .frame(width: 48, height: 48)
            }
        }
        .sheet(isPresented: $showInfoView) {
            AboutView(showInfoView: $showInfoView)
                .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
                .environmentObject(vm)
        }
        .sheet(isPresented: $showFilterView) {
            FilterView(showFilterView: $showFilterView)
                .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
                .environmentObject(vm)
        }
    }
}
