//
//  FeedbackView.swift
//  FeedbackView
//
//  Created by William Finnis on 10/08/2021.
//

import SwiftUI
import StoreKit

struct FeedbackView: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        Form {
            Text("")
        }
        .navigationTitle("Feedback")
        .sheet(isPresented: $vm.showShareView) {
            ShareView()
                .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
        }
    }
}
