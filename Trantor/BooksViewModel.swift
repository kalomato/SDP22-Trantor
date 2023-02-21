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
    
    @Published var showAlert            = false
    @Published var errorMSG             = ""
    
    init() {
        Task {
            await getBooks()
            //await getAuthors()
        }
    }
    
    //MainActor para poder tocar valores del hilo principal
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
    
//    @MainActor func getAuthors() async {
//        do {
//            authors = try await persistence.getAuthors()
//        } catch {
//            errorMSG = error.localizedDescription
//            showAlert.toggle()
//        }
//    }

}

