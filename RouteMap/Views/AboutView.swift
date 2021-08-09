//
//  AboutView.swift
//  AboutView
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct AboutView: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("NCCR")) {
                    Text("The Norfolk Churches Cycling Routes (NCCR) are a series of cycling routes around Norfolk which visit all of its medieval churches.")
                }
                Section(header: Text("The Churches")) {
                    Text("Norfolk has the highest density of medieval churches in the world. The routes visit over 600 churches and each church is over 500 years old.")
                }
                Section(header: Text("The Routes")) {
                    Text("There are 26 routes covering over 2,100 km of beautiful Norfolk countryside. Each route starts and ends at a town with a car park and train station for ease of access.")
                }
                Section(header: Text("The Website")) {
                    Button {
                        let url = URL(string: "http://ncct.cs_s_bahadur.repl.co")!
                        UIApplication.shared.open(url)
                    } label: {
                        Text("Explore the ") +
                        Text("NCCR website")
                            .foregroundColor(.accentColor)
                    }
                }
                Section(header: Text("Acknowledgments")) {
                    Button {
                        let url = URL(string: "http://norfolkchurches.co.uk/mainpage.htm")!
                        UIApplication.shared.open(url)
                    } label: {
                        Text("With thanks to Simon Knott for supplying a detailed analysis of all Norfolk's medieval churches on his ") +
                        Text("website")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .buttonStyle(.plain)
            .navigationTitle("About")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        vm.showInfoView = false
                    } label: {
                        Text("Done")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.showShareView = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .sheet(isPresented: $vm.showShareView) {
            ShareView()
                .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
        }
    }
}
