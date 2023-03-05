//
//  ContentView.swift
//  Trantor
//
//  Created by Enrique on 5/2/23.
//

import SwiftUI

struct BooksView: View {
    @EnvironmentObject var booksVM:BooksViewModel
    @EnvironmentObject var userVM:UserViewModel
    
    var body: some View {
        NavigationStack {
            List(booksVM.orderedBooks) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
                }
            }            
            .navigationTitle("Todos los Libros")
            .navigationDestination(for: Books.self) { book in
                BookDetailView(bookDetailVM: BookDetailViewVM(book: book))
            }
            .searchable(text: $booksVM.searchText, prompt: "Buscar en todos los libros") {
                if booksVM.filterBooks.isEmpty {
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
                await booksVM.getBooks()
            }
        }
        .alert("ERROR", isPresented: $booksVM.showAlert) {
            Button(action: {}) {
                Text("OK")
            }
        } message: {
            Text(booksVM.errorMSG)
        }
    }
}


struct BooksView_Previews: PreviewProvider {
    static let booksVM = BooksViewModel()
    static let userVM = UserViewModel()
    static var previews: some View {
        BooksView()
            .environmentObject(booksVM)
            .environmentObject(userVM)
            .task {
                await booksVM.getBooks()
            }
    }
}
