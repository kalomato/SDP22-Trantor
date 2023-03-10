//
//  FavoritesView.swift
//  Trantor
//
//  Created by Enrique on 18/2/23.
//

import SwiftUI

struct ReadedView: View {
    @EnvironmentObject var userVM:UserViewModel
    @EnvironmentObject var booksVM:BooksViewModel
    @EnvironmentObject var readedVM:ReadedViewModel
    
    @State var showAlert = false
    @State var alertMsg  = ""
    @State private var isLoading = true
    @State private var firstLoad = true
    
    var body: some View {
        NavigationStack {
            if readedVM.orderedReadedBooks.count == 0 && !isLoading && readedVM.searchText.count == 0 {
                Text ("No hay libros leídos por \(userVM.usuario.name)")
            }
            List(readedVM.orderedReadedBooks) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                Task {
                                    if (await booksVM.toggleReaded(email: userVM.usuario.email, bookID: [book.id])) {
                                        await booksVM.getReaded(email: userVM.usuario.email)
                                        await readedVM.getReadedBooks(email: userVM.usuario.email)
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
            .navigationTitle("Libros leídos")
            .navigationDestination(for: Books.self) { book in
                BookDetailView(bookDetailVM: BookDetailViewVM(book: book))
            }
            .searchable(text: $readedVM.searchText, prompt: "Buscar en leídos") {
                if readedVM.filterReadedBooks.isEmpty {
                    NoSearchResult()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Ordenar") {
                        ForEach(ReadedViewModel.SortType.allCases, id:\.self) { option in
                            Button {
                                readedVM.sortType = option
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
            .onAppear {
                //isLoading = true
                Task {
                    if firstLoad {
                        await readedVM.getReadedBooks(email: userVM.usuario.email)
                        isLoading = false
                    }
                }
            }
            .refreshable {
                isLoading = true
                await readedVM.getReadedBooks(email: userVM.usuario.email)
                isLoading = false
            }
            .overlay {
                if isLoading {
                    LoadingView()
                        .transition(.opacity)
                }
            }
        }
        .alert("ERROR",
               isPresented: $readedVM.showAlert) {
            Button(action: {}) {
                Text("OK")
            }
        } message: {
            Text(readedVM.errorMSG)
        }
    }
    
}


struct ReadedView_Previews: PreviewProvider {
    static let booksVM = BooksViewModel()
    static let readedVM = ReadedViewModel()
    static let userVM = UserViewModel()
    static var previews: some View {
        ReadedView()
            .environmentObject(readedVM)
            .environmentObject(userVM)
            .environmentObject(booksVM)
            .task {
                await readedVM.getReadedBooks(email: "enrique@tizona.net")
            }
    }
}
