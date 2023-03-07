//
//  ReadedViewModel.swift
//  Trantor
//
//  Created by Enrique Suárez on 3/3/23.
//

import SwiftUI

final class ReadedViewModel:ObservableObject {
    let persistence = NetworkPersistence.shared
    @EnvironmentObject var userVM:UserViewModel

    @Published var readedBooks:[Books]  = []
    @Published var searchText           = ""
    @Published var sortType:SortType    = .noSort
    @Published var showAlert            = false
    @Published var errorMSG             = ""
    
    enum SortType:String, CaseIterable {
        case titleAscending   = "Por título ascendente"
        case titleDescending  = "Por título descendente"
        case authorAscending  = "Por autor ascendente"
        case authorDescending = "Por autor descendente"
        case yearAscending    = "Por año ascendente"
        case yearDescending   = "Por año descendente"
        case noSort           = "Por defecto"
    }
    
    var filterReadedBooks:[Books] {
        if searchText.isEmpty {
            return readedBooks.sorted { $0.id < $1.id }
        } else {
            return readedBooks.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.author.lowercased().contains(searchText.lowercased()) ||
                ($0.plot?.lowercased().contains(searchText.lowercased()) ?? false) ||
                ($0.summary?.lowercased().contains(searchText.lowercased()) ?? false) ||
                $0.year.description.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var orderedReadedBooks:[Books] {
        switch sortType {
        case .titleAscending:
            return filterReadedBooks.sorted { $0.title < $1.title }
        case .titleDescending:
            return filterReadedBooks.sorted { $0.title > $1.title }
        case .authorAscending:
            return filterReadedBooks.sorted { $0.author < $1.author }
        case .authorDescending:
            return filterReadedBooks.sorted { $0.author > $1.author }
        case .yearAscending:
            return filterReadedBooks.sorted { $0.year < $1.year }
        case .yearDescending:
            return filterReadedBooks.sorted { $0.year > $1.year }
        case .noSort:
            return filterReadedBooks
        }
    }
    
    
    @MainActor func getReadedBooks(email:String) async {
        do {
            if email.isEmpty || email == "Sin email" {
                return
            }
            readedBooks = try await persistence.getReadedBooks(email: email)
            self.readedBooks = readedBooks
        } catch let error as APIErrors {
            errorMSG = error.description
            showAlert.toggle()
        } catch {
            errorMSG = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func reset() {
        self.readedBooks = []
    }
}


