//
//  NetworkPersistence.swift
//  Trantor
//
//  Created by Enrique on 14/2/23.
//

import SwiftUI

final class NetworkPersistence {
    static let shared = NetworkPersistence()
    
    //de momento sin control de errores
    func getBooks() async throws -> [Books] {
        let (data, _) = try await URLSession.shared.data(from: .getBooks)
        return try JSONDecoder().decode([Books].self, from: data)
    }
    
    func getAuthors() async throws -> [Authors] {
        let (data, _) = try await URLSession.shared.data(from: .getAuthors)
        return try JSONDecoder().decode([Authors].self, from: data)
    }

    
}
