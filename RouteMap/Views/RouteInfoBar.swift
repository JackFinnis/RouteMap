//
//  RouteInfoBar.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI

struct RouteInfoBar: View {
    @EnvironmentObject var routesVM: RoutesVM
    @EnvironmentObject var mapVM: MapVM
    
    @State var showWorkoutDetailSheet: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                Button {
                    routesVM.previousRoute()
                } label: {
                    Image(systemName: "chevron.backward")
                        .frame(width: 40, height: 40)
                }
                
                Text(routesVM.selectedWorkoutDistanceString)
                    .font(.headline)
                Spacer()
                
                Button {
                    routesVM.nextRoute()
                } label: {
                    Image(systemName: "chevron.forward")
                        .frame(width: 40, height: 40)
                }
            }
            .frame(height: 70)
            .background(Blur())
            .cornerRadius(12)
            .compositingGroup()
            .shadow(radius: 2, y: 2)
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
