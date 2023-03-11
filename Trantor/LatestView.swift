//
//  LatestView.swift
//  Trantor
//
//  Created by Enrique on 18/2/23.
//

import SwiftUI

struct LatestView: View {
    @EnvironmentObject var booksVM:BooksViewModel
    @EnvironmentObject var userVM:UserViewModel
    
    @State var showAlert = false
    @State var alertMsg  = ""
    
    var body: some View {
        NavigationStack {
            List(booksVM.orderedLatestBooks) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                Task {
                                    if (await booksVM.toggleReaded(email: userVM.usuario.email, bookID: [book.id])) {
                                        await booksVM.getReaded(email: userVM.usuario.email)
                                    } else {
                                        showAlert = true
                                        alertMsg = "Error, intente de nuevo"
                                    }
                                }
                            } label: {
                                !booksVM.readedBooks.books.contains(book.id) ?
                                    Label("Marcar Leído", systemImage: "bookmark") :
                                    Label("Quitar Leído", systemImage: "bookmark.slash")
                            }
                            .tint(booksVM.readedBooks.books.contains(book.id) ? .red : .green)
                        }
                }
            }
            .navigationTitle("Novedades")
            .navigationDestination(for: Books.self) { book in
                BookDetailView(bookDetailVM: BookDetailViewVM(book: book))
            }
            .searchable(text: $booksVM.searchText, prompt: "Buscar en novedades") {
                if booksVM.filterLatestBooks.isEmpty {
                    NoSearchResult()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Ordenar") {
                        ForEach(BooksViewModel.SortType.allCases, id:\.self) { option in
                            Button {
                                booksVM.sortType = option
                            } label: {
                                Text(option.rawValue)
                            }
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    UserMenu(user: userVM.usuario)
                }
            }
            .refreshable {
                await booksVM.getBooksLatest()
            }
            .onAppear {
                Task {
                    do {
                        await booksVM.getBooksLatest()
                    }
                }
            }
        }
        .alert("ERROR",
               isPresented: $booksVM.showAlert) {
            Button(action: {}) {
                Text("OK")
            }
        } message: {
            Text(booksVM.errorMSG)
        }
    }
}


struct LatestView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User.userTest
        let userVM = UserViewModel()
        userVM.usuario = user
        return LatestView()
            .environmentObject(BooksViewModel())
            .environmentObject(userVM)
            .task {
                await BooksViewModel().getBooksLatest()
            }
    }
}
