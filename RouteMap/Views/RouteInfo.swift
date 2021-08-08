//
//  RouteInfo.swift
//  RouteInfo
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct RouteInfo: View {
    @EnvironmentObject var vm: ViewModel
    
    var route: Route
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(route.name)
                    .font(.headline)
                Text(route.stage)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(String(Int(route.metres / 1_000)) + " km")
                Text(String(route.churches.count) + " Churches")
                Text(String(format: "%.1f", route.density) + " km/Church")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
    }
}
