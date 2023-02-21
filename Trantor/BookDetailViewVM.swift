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
    
    //Datos que se vayan a editar
//    @Published var pages:Int = 0
//    @Published var year:Int = 0
//    @Published var isbn:String = ""
//    @Published var title:String = ""
    var bookAuthor:String = ""
    
    
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
            bookAuthor = try await persistence.getAuthor(id: book.author)
//            pages = book?.pages ?? 0
//            isbn = book?.isbn ?? "-"
//            year = book?.year ?? 0
//            title = book?.title ?? "-"
        } catch let error as APIErrors {
            errorMSG = error.description
            showError.toggle()
        } catch {
            errorMSG = error.localizedDescription
            showError.toggle()
        }
    }
}
