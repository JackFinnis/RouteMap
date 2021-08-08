//
//  RouteBar.swift
//  RouteBar
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct RouteBar: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        HStack {
            Button {
                vm.previousRoute()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 23))
                    .frame(width: 46, height: 46)
            }
            
            if vm.selectedRoute != nil {
                Text(String(vm.filteredRoutes.firstIndex(of: vm.selectedRoute!)!))
                    .frame(width: 46, height: 46)
                NavigationLink(destination: RouteView(route: vm.selectedRoute!)) {
                    Text(vm.selectedRoute == nil ? "" : vm.selectedRoute!.name)
                        .font(.headline)
                        .lineLimit(1)
                }
                .buttonStyle(.plain)
            } else {
                Button {
                    vm.selectFirstRoute()
                } label: {
                    Text("Sort Routes")
                }
            }
            
            Spacer()
            Button {
                vm.nextRoute()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 23))
                    .frame(width: 46, height: 46)
            }
        }
    }
}
