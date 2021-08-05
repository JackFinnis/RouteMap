//
//  URLSession.swift
//  URLSession
//
//  Created by William Finnis on 05/08/2021.
//

import Foundation

extension URLSession {
    func decode<T: Decodable>(_ type: T.Type = T.self, from url: URL) async throws -> T {
        let (data, _) = try await data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
