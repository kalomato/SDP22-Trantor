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

//    init(readedBooks:[Books]) {
//        Task {
//            await getReadedBooks(email: email)
//        }
//    }
    
    enum SortType:String, CaseIterable {
        case ratingAscending  = "Por valoración (0-9)"
        case ratingDescending = "Por valoración (9-0)"
        case titleAscending   = "Por título (A-Z)"
        case titleDescending  = "Por título (Z-A)"
        case authorAscending  = "Por autor (A-Z)"
        case authorDescending = "Por autor (Z-A)"
        case priceAscending   = "Por precio (0-9)"
        case priceDescending  = "Por precio (9-0)"
        case yearAscending    = "Por año (0-9)"
        case yearDescending   = "Por año (9-0)"
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
        case .ratingAscending:
            return filterReadedBooks.sorted { $0.rating ?? 0 < $1.rating ?? 0 }
        case .ratingDescending:
            return filterReadedBooks.sorted { $0.rating ?? 0 > $1.rating ?? 0 }
        case .titleAscending:
            return filterReadedBooks.sorted { $0.title < $1.title }
        case .titleDescending:
            return filterReadedBooks.sorted { $0.title > $1.title }
        case .authorAscending:
            return filterReadedBooks.sorted { $0.author < $1.author }
        case .authorDescending:
            return filterReadedBooks.sorted { $0.author > $1.author }
        case .priceAscending:
            return filterReadedBooks.sorted { $0.price < $1.price }
        case .priceDescending:
            return filterReadedBooks.sorted { $0.price > $1.price }
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


