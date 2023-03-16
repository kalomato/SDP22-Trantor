//
//  TrantorViewModel.swift
//  Trantor
//
//  Created by Enrique on 5/2/23.
//

import SwiftUI

final class BooksViewModel:ObservableObject {
    let persistence = NetworkPersistence.shared
    @EnvironmentObject var userVM:UserViewModel
    
    @Published var books:[Books]           = []
    @Published var booksLatest:[Books]     = []
    @Published var searchText              = ""
    @Published var sortType:SortType       = .noSort
    @Published var readedBooks:ReadedBooks = ReadedBooks(books: [], email: "")
    
    @Published var showAlert    = false
    @Published var errorMSG     = ""
    @State var booksLoading     = true
    
    enum SortType:String, CaseIterable {
        case ratingAscending  = "Por valoración ascencente"
        case ratingDescending = "Por valoración descendente"
        case titleAscending   = "Por título ascendente"
        case titleDescending  = "Por título descendente"
        case authorAscending  = "Por autor ascendente"
        case authorDescending = "Por autor descendente"
        case priceAscending   = "Por precio ascendente"
        case priceDescending  = "Por precio descendente"
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
        case .ratingAscending:
            return filterBooks.sorted { $0.rating ?? 0 < $1.rating ?? 0 }
        case .ratingDescending:
            return filterBooks.sorted { $0.rating ?? 0 > $1.rating ?? 0 }
        case .titleAscending:
            return filterBooks.sorted { $0.title < $1.title }
        case .titleDescending:
            return filterBooks.sorted { $0.title > $1.title }
        case .authorAscending:
            return filterBooks.sorted { $0.author < $1.author }
        case .authorDescending:
            return filterBooks.sorted { $0.author > $1.author }
        case .priceAscending:
            return filterBooks.sorted { $0.price < $1.price }
        case .priceDescending:
            return filterBooks.sorted { $0.price > $1.price }
        case .yearAscending:
            return filterBooks.sorted { $0.year < $1.year }
        case .yearDescending:
            return filterBooks.sorted { $0.year > $1.year }
        case .noSort:
            return filterBooks
        }
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
        case .ratingAscending:
            return filterLatestBooks.sorted { $0.rating ?? 0 < $1.rating ?? 0 }
        case .ratingDescending:
            return filterLatestBooks.sorted { $0.rating ?? 0 > $1.rating ?? 0 }
        case .titleAscending:
            return filterLatestBooks.sorted { $0.title < $1.title }
        case .titleDescending:
            return filterLatestBooks.sorted { $0.title > $1.title }
        case .authorAscending:
            return filterLatestBooks.sorted { $0.author < $1.author }
        case .authorDescending:
            return filterLatestBooks.sorted { $0.author > $1.author }
        case .priceAscending:
            return filterLatestBooks.sorted { $0.price < $1.price }
        case .priceDescending:
            return filterLatestBooks.sorted { $0.price > $1.price }
        case .yearAscending:
            return filterLatestBooks.sorted { $0.year < $1.year }
        case .yearDescending:
            return filterLatestBooks.sorted { $0.year > $1.year }
        case .noSort:
            return filterLatestBooks
        }
    }
    
    
    init() {
        booksLoading = true
        Task {
            await getBooks()
            await getBooksLatest()
            booksLoading = false
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
    
    func toggleReaded(email:String, bookID:[Int]) async -> Bool {
        do {
            return try await persistence.markRead(email: email, booksID: bookID)
        } catch let error as APIErrors {
            errorMSG = error.description
            showAlert.toggle()
        } catch {
            errorMSG = error.localizedDescription
            showAlert.toggle()
        }
        return false
    }
    
    func getReaded(email: String) async {
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
    
    func isReaded(email:String, bookID:Int) async -> Bool {
        var readed:Bool = false
            do {
                readed = try await persistence.isReaded(email: email, bookID: bookID).readed
            } catch let error as APIErrors {
                errorMSG = error.description
                showAlert.toggle()
            } catch {
                errorMSG = error.localizedDescription
                showAlert.toggle()
            }
        return readed
    }
    
    func reset() {
        self.books       = []
        self.booksLatest = []
    }
    
}
