//
//  RouteView.swift
//  RouteView
//
//  Created by William Finnis on 05/08/2021.
//

import SwiftUI

struct RouteView: View {
    let route: Route
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                HStack {
                    Text("Route Number")
                    Spacer()
                    Text(route.stage)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(route.name)
    }
}
