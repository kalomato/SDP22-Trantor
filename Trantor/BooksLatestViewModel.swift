//
//  BooksLatestViewModel.swift
//  Trantor
//
//  Created by Enrique on 22/2/23.
//

import SwiftUI

final class BooksLatestViewModel:ObservableObject {
    let persistence = NetworkPersistence.shared
    
    @Published var booksLatest:[Books]  = []
    @Published var authors:[Authors]    = []
    @Published var searchText           = ""
    @Published var sortType:SortType    = .noSort
    @Published var readedBooks:ReadedBooks    = ReadedBooks(books: [], email: "")
    
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
    
    var filterLatestBooks:[Books] {
        if searchText.isEmpty {
            return booksLatest.sorted { $0.id < $1.id }
        } else {
            return booksLatest.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.author.lowercased().contains(searchText.lowercased()) ||
                ($0.plot?.lowercased().contains(searchText.lowercased()) ?? false) ||
                ($0.summary?.lowercased().contains(searchText.lowercased()) ?? false) ||
                $0.year.description.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var orderedLatestBooks:[Books] {
        switch sortType {
        case .titleAscending:
            return filterLatestBooks.sorted { $0.title < $1.title }
        case .titleDescending:
            return filterLatestBooks.sorted { $0.title > $1.title }
        case .authorAscending:
            return filterLatestBooks.sorted { $0.author < $1.author }
        case .authorDescending:
            return filterLatestBooks.sorted { $0.author > $1.author }
        case .yearAscending:
            return filterLatestBooks.sorted { $0.year < $1.year }
        case .yearDescending:
            return filterLatestBooks.sorted { $0.year > $1.year }
        case .noSort:
            return filterLatestBooks
        }
    }
    
    init() {
        Task {
            await getBooksLatest()
        }
    }
    
    @MainActor func getBooksLatest() async {
        do {
            booksLatest = try await persistence.getBooksLatest()
        } catch let error as APIErrors {
            errorMSG = error.description
            showAlert.toggle()
        } catch {
            errorMSG = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    @MainActor func getReaded(email: String) async {
        do {
            readedBooks = try await persistence.readedBooks(email: email)
        } catch let error as APIErrors {
            errorMSG = error.description
            showAlert.toggle()
        } catch {
            errorMSG = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func reset() {
        self.booksLatest = []
    }
    
}
