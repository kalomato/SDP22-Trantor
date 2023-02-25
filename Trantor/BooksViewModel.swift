//
//  TrantorViewModel.swift
//  Trantor
//
//  Created by Enrique on 5/2/23.
//

import SwiftUI

final class BooksViewModel:ObservableObject {
    let persistence = NetworkPersistence.shared
    
    @Published var books:[Books]        = []
    @Published var authors:[Authors]    = []
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
    
    var filterBooks:[Books] {
        if searchText.isEmpty {
            return books.sorted { $0.id < $1.id }
        } else {
            return books.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.author.lowercased().contains(searchText.lowercased()) ||
                ($0.plot?.lowercased().contains(searchText.lowercased()) ?? false) ||
                ($0.summary?.lowercased().contains(searchText.lowercased()) ?? false) ||
                $0.year.description.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var orderedBooks:[Books] {
        switch sortType {
        case .titleAscending:
            return filterBooks.sorted { $0.title < $1.title }
        case .titleDescending:
            return filterBooks.sorted { $0.title > $1.title }
        case .authorAscending:
            return filterBooks.sorted { $0.author < $1.author }
        case .authorDescending:
            return filterBooks.sorted { $0.author > $1.author }
        case .yearAscending:
            return filterBooks.sorted { $0.year < $1.year }
        case .yearDescending:
            return filterBooks.sorted { $0.year > $1.year }
        case .noSort:
            return filterBooks
        }
    }
    
    init() {
        Task {
            await getBooks()
        }
    }
    
    @MainActor func getBooks() async {
        do {
            books = try await persistence.getBooks()
        } catch let error as APIErrors {
            errorMSG = error.description
            showAlert.toggle()
        } catch {
            errorMSG = error.localizedDescription
            showAlert.toggle()
        }
    }
}

