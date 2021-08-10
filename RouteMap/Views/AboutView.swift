//
//  AboutView.swift
//  AboutView
//
//  Created by William Finnis on 08/08/2021.
//

import SwiftUI
import StoreKit

struct AboutView: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationView {
            Form {
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
                    Text("There are 26 routes covering over 2,100 km of beautiful Norfolk countryside. Each route starts and ends at a town with a car park and train station for ease of access.")
                }
                
                Section(header: Text("Feedback")) {
                    Button {
                        vm.showShareView = true
                    } label: {
                        Label("Share NCCR", systemImage: "square.and.arrow.up")
                    }
                    Button {
                        if let windowScene = UIApplication.shared.windows.first?.windowScene {
                            SKStoreReviewController.requestReview(in: windowScene)
                        }
                    } label: {
                        Label("Rate NCCR", systemImage: "star")
                    }
                    Button {
                        let url = URL(string: "mailto:jackfinnis@btinternet.com")!
                        UIApplication.shared.open(url)
                    } label: {
                        Label("Send us Feedback", systemImage: "envelope")
                    }
                    Button {
                        let productUrl = URL(string: "https://itunes.apple.com")!
                        var components = URLComponents(url: productUrl, resolvingAgainstBaseURL: false)
                        components?.queryItems = [
                            URLQueryItem(name: "action", value: "write-review")
                        ]
                        if let url = components?.url {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Review on the App Store", systemImage: "text.bubble")
                    }
                    NavigationLink(destination: TipView()) {
                        Label("Tip Jar", systemImage: "heart")
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
            }
        }
        .sheet(isPresented: $vm.showShareView) {
            ShareView()
                .preferredColorScheme(vm.mapType == .standard ? .none : .dark)
        }
    }
}
