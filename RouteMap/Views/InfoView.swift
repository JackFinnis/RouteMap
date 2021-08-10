//
//  InfoView.swift
//  InfoView
//
//  Created by William Finnis on 10/08/2021.
//

import SwiftUI
import StoreKit

struct InfoView: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Visited")) {
                    Label {
                        if vm.visitedRoutes.count == 26 {
                            Text("You have cycled every route!")
                        } else {
                            HStack {
                                Text(String(vm.visitedRoutes.count) + "/26 Routes ")
                                Spacer()
                                Text(vm.getDistanceCycled() + "/2,116km")
                                    .foregroundColor(.secondary)
                            }
                        }
                    } icon: {
                        Image(systemName: "bicycle")
                    }
                    
                    Label {
                        if vm.visitedChurches.count == 632 {
                            Text("You have visited every medieval church in Norfolk!")
                        } else {
                            Text(String(vm.visitedChurches.count) + "/632 Churches")
                        }
                    } icon: {
                        Image("cross")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.accentColor)
                            .frame(height: 24)
                    }
                }
                
                Section(header: Text("About")) {
                    NavigationLink(destination: AboutView()) {
                        Label("About NCCR", systemImage: "info.circle")
                    }
                }
                
                Section(header: Text("Feedback"), footer: Text("We read and reply to every feedback. Please consider giving us feedback to help us improve the app.")) {
                    NavigationLink(destination: TipView()) {
                        Label("Tip Jar", systemImage: "heart")
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
                }
            }
            .navigationTitle("Info")
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
                        Label("Share NCCR", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}
