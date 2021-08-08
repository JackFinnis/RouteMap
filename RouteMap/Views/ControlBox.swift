//
//  ControlBox.swift
//  ControlBox
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct ControlBox: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ActionBar()
            Divider()
            
            if vm.showSearchBar {
                SearchBar(text: $vm.searchText)
                    .placeholder("Churches, Destinations and Locations")
            }
            
            if vm.showRouteBar {
                RouteBar()
            }
        }
        .background(Blur())
        .cornerRadius(10)
        .compositingGroup()
        .shadow(color: Color(UIColor.systemFill), radius: 5)
        .padding(10)
    }
}
