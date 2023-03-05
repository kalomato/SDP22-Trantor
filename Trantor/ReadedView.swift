//
//  FavoritesView.swift
//  Trantor
//
//  Created by Enrique on 18/2/23.
//

import SwiftUI

struct ReadedView: View {
    @EnvironmentObject var booksVM:BooksViewModel
    @EnvironmentObject var readedVM:ReadedViewModel
    @EnvironmentObject var userVM:UserViewModel
    
    @State var isLoading = true
    
    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView()
            } else if readedVM.orderedReadedBooks.count == 0 {
                Text ("No hay libros leídos por \(userVM.usuario.name)")
            }
            List(readedVM.orderedReadedBooks) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
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
                isLoading = true
                Task {
                    await readedVM.getReadedBooks(email: userVM.usuario.email)
                    isLoading = false
                }
            }
            
            .refreshable {
                await readedVM.getReadedBooks(email: userVM.usuario.email)
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
