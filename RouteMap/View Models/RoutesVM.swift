//
//  RoutesVM.swift
//  RoutesVM
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation

@MainActor
class RoutesVM: ObservableObject {
    @Published var routes = [Route]()
    
    func loadRoutes() async {
        do {
            let url = URL(string: "https://ncct-api.finnisjack.repl.co/routes.json")!
            routes = try await URLSession.shared.decode(from: url)
        } catch {
            print(error.localizedDescription)
        }
    }
}
