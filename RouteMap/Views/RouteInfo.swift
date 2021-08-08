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
            VStack {
                Text(route.name)
                    .font(.headline)
                Text(route.stage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack {
                Label {
                    Text(String(route.churches.count))
                } icon: {
                    Image("cross")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(11.5)
                        .frame(width: 46, height: 46)
                }
                Text(String(Int(route.metres / 1_000)) + " km")
            }
        }
    }
}
