//
//  CommonSwipeActions.swift
//  Trantor
//
//  Created by Enrique on 15/3/23.
//

import SwiftUI

struct CommonSwipeActions {
    @ViewBuilder static func swipeActions(book: Books, booksVM: BooksViewModel, userVM: UserViewModel, cartVM: CartViewModel, readedVM: ReadedViewModel) -> some View {
        HStack {
            Button {
                Task {
                    let _ = await booksVM.toggleReaded(email: userVM.usuario.email, bookID: [book.id])
                    await booksVM.getReaded(email: userVM.usuario.email)
                    await readedVM.getReadedBooks(email: userVM.usuario.email)
                }
            } label: {
                !booksVM.readedBooks.books.contains(book.id) ?
                Label("Leído", systemImage: "bookmark") :
                Label("No Leído", systemImage: "bookmark.slash")
            }
            .tint(booksVM.readedBooks.books.contains(book.id) ? .red : .green)
            Button {
                cartVM.addToCart(bookID: book.id)
            } label:  {
                cartVM.isInCart(bookID: book.id) ?
                Label("Comprar más", systemImage: "cart.fill.badge.plus") :
                Label("Comprar", systemImage: "cart.badge.plus")
            }
            .tint(.blue)
        }
    }
}

