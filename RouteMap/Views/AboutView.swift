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
            Section(header: Text("NCCR")) {
                Button {
                    let url = URL(string: "https://nccr.finnisjack.repl.co")!
                    UIApplication.shared.open(url)
                } label: {
                    Text("The Norfolk Churches Cycling Routes (NCCR) are a series of cycling routes around Norfolk which visit all of its medieval churches. Explore the ") +
                    Text("NCCR website")
                        .foregroundColor(.accentColor)
                }
            }
            
            Section(header: Text("The Churches")) {
                Text("Norfolk has the highest density of medieval churches in the world. The routes visit 632 churches and each church is over 500 years old.")
            }
            
            Section(header: Text("The Routes")) {
                Text("There are 26 routes covering over 2,116km of beautiful Norfolk countryside. Each route starts and ends at a town with a car park and train station for ease of access.")
            }
            
            Section(header: Text("Acknowledgments")) {
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
