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
    
    @Published var showAlert            = false
    @Published var errorMSG             = ""
    
    var filterBooks:[Books] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                ($0.author.lowercased().contains(searchText.lowercased())) ||
                ($0.plot?.lowercased().contains(searchText.lowercased()) ?? false) ||
                ($0.summary?.lowercased().contains(searchText.lowercased()) ?? false) ||
                ($0.year.description.lowercased().contains(searchText.lowercased()))
            }
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

