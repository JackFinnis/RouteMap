//
//  MapSettings.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI
import CoreLocation

struct MapSettings: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                vm.updateMapType()
            } label: {
                Image(systemName: vm.mapTypeImage)
                    .frame(width: 46, height: 46)
            }
            
            Divider()
                .frame(width: 46)
            
            Button {
                vm.updateTrackingMode()
            } label: {
                Image(systemName: vm.trackingModeImage)
                    .frame(width: 46, height: 46)
            }
        }
        .font(.system(size: 23))
        .background(Blur())
        .cornerRadius(10)
        .compositingGroup()
        .shadow(color: Color(UIColor.systemFill), radius: 5)
        .padding(.trailing, 10)
        .padding(.top, 50)
    }
}
