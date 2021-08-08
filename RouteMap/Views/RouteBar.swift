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
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                Button {
                    vm.previousRoute()
                } label: {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 23))
                        .frame(width: 46, height: 46)
                }
                
                Button {
                    vm.nextRoute()
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 23))
                        .frame(width: 46, height: 46)
                }
            }
            
            if vm.selectedRoute != nil && vm.showRouteBar {
                ZStack {
                    NavigationLink(destination: RouteView(route: vm.selectedRoute!)) {
                        Spacer().frame(height: 92)
                    }
                    RouteInfo(route: vm.selectedRoute!)
                        .animation(.none)
                }
            }
            
            Spacer()
            VStack(spacing: 0) {
                Button {
                    vm.focusOnSelected.toggle()
                } label: {
                    Image(systemName: vm.focusOnSelectedImage)
                        .font(.system(size: 23))
                        .frame(width: 46, height: 46)
                }
                
                Button {
                    vm.selectedRoute = nil
                    vm.showRouteBar = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 23))
                        .frame(width: 46, height: 46)
                }
            }
        }
    }
}
