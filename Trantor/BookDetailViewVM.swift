//
//  BookDetailViewModel.swift
//  Trantor
//
//  Created by Enrique on 19/2/23.
//

import SwiftUI

final class BookDetailViewVM:ObservableObject {
    let persistence = NetworkPersistence.shared
    let book:Books
    
    //Se me ha ocurrido tratar los valores opcionales aquí, para que en la vista BookDetailView
    //no tenga que preocuparme de ello. No sé si es el mejor modo.
    @Published var summary:String          = "Resumen no disponible"
    @Published var plot:String             = "Argumento no disponible"
    @Published var isbn:String             = "ISBN no disponible"
    @Published var pages:String            = "no disponible"
    @Published var rating:Double           = 0
    @Published var readedBooks:ReadedBooks = ReadedBooks(books: [], email: "")
    
    @Published var showError = false
    @Published var errorMSG  = ""
    
    init(book:Books) {
        self.book = book
        Task {
            await getBook()
        }
    }
    
    @MainActor func getBook() async {
        do {
            let _ = try await persistence.getBook(id: book.id)
            pages   = book.pages?.description ?? pages
            summary = book.summary ?? summary
            plot    = book.plot ?? plot
            isbn    = book.isbn ?? isbn
            rating  = book.rating ?? rating
        } catch let error as APIErrors {
            errorMSG = error.description
            showError.toggle()
        } catch {
            errorMSG = error.localizedDescription
            showError.toggle()
        }
    }
    
    @MainActor func getReaded(email: String) async {
        do {
            readedBooks = try await persistence.readedBooks(email: email)
        } catch let error as APIErrors {
            errorMSG = error.description
            showError.toggle()
        } catch {
            errorMSG = error.localizedDescription
            showError.toggle()
        }
    }
        
}
