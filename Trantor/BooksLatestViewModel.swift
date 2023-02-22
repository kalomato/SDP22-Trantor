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
    
    @Published var showAlert            = false
    @Published var errorMSG             = ""
    
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
