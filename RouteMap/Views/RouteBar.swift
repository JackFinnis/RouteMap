//
//  RouteBar.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI

struct RouteBar: View {
    @EnvironmentObject var routesVM: RoutesVM
    
    @State var showWorkoutDetailSheet: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                Button {
                    routesVM.previousRoute()
                } label: {
                    Image(systemName: "chevron.backward")
                        .frame(width: 46, height: 46)
                }
                
                Text(routesVM.selectedRoute == nil ? "" : routesVM.selectedRoute!.name)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                
                Button {
                    routesVM.nextRoute()
                } label: {
                    Image(systemName: "chevron.forward")
                        .frame(width: 46, height: 46)
                }
            }
            .font(.system(size: 23))
            .background(Blur())
            .cornerRadius(10)
            .compositingGroup()
            .shadow(color: Color(UIColor.systemFill), radius: 5)
            .padding(10)
            .onTapGesture {
                if routesVM.selectedRoute != nil {
                    showWorkoutDetailSheet = true
                }
            }
        }
        .sheet(isPresented: $showWorkoutDetailSheet) {
            RouteView(route: routesVM.selectedRoute!)
        }
    }
}
