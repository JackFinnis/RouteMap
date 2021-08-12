//
//  AboutView.swift
//  AboutView
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section(header: Text("NCCR").buttonStyle(.plain)) {
                Text("The Norfolk Churches Cycling Routes are a series of cycling routes around Norfolk which visit all of its medieval churches.")
            }
            
            Section(header: Text("The Churches").buttonStyle(.plain)) {
                Text("Norfolk has the highest density of medieval churches in the world. The routes visit 632 churches and each church has substantial medieval fabric.")
            }
            
            Section(header: Text("The Routes").buttonStyle(.plain)) {
                Text("There are 26 routes covering over 2,116km of beautiful Norfolk countryside. Each route starts and ends at a town with a car park and every other town also has a train station for ease of access.")
            }
            
            Section(header: Text("Acknowledgments").buttonStyle(.plain)) {
                Button {
                    let url = URL(string: "http://norfolkchurches.co.uk/mainpage.htm")!
                    UIApplication.shared.open(url)
                } label: {
                    Text("With thanks to Simon Knott for supplying a detailed analysis of every church in Norfolk on his ") +
                    Text("website")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .listStyle(.sidebar)
        .buttonStyle(.plain)
        .navigationTitle("About")
    }
}
