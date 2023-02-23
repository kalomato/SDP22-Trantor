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
    @Published var search               = ""
    
    @Published var showAlert            = false
    @Published var errorMSG             = ""
    
    var filterLatestBooks:[Books] {
        if search.isEmpty {
            return booksLatest
        } else {
            return booksLatest.filter {
                $0.title.lowercased().contains(search.lowercased())
            }
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
    
}
