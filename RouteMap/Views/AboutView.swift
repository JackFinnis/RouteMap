//
//  AboutView.swift
//  AboutView
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct AboutView: View {
    @EnvironmentObject var vm: ViewModel
    
    @State var showShareView: Bool = false
    
    @Binding var showInfoView: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("NCCR")) {
                    Text("The Norfolk Churches Cycling Routes (NCCR) are a series of cycling routes around Norfolk which visit all of its medieval churches.")
                }
                Section(header: Text("The Churches")) {
                    Text("Norfolk has the highest density of medieval churches in the world. All the churches you will see on the routes are over 500 years old.")
                }
                Section(header: Text("The Routes")) {
                    Text("Each route starts and ends at a town with a car park and train station for ease of access.")
                }
                Section(header: Text("Acknowledgments")) {
                    Text("With thanks to Simon Knott for supplying a detailed analysis of all of Norfolk's medieval churches. See his work ") + Text("here").foregroundColor(.accentColor)
                }
                .onTapGesture {
                    let url = URL(string: "http://norfolkchurches.co.uk/mainpage.htm")!
                    UIApplication.shared.open(url)
                }
            }
            .navigationTitle("About")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showInfoView = false
                    } label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showShareView = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .sheet(isPresented: $showShareView) {
            ShareView()
                .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
        }
    }
}
