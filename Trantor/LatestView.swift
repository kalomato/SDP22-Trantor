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
    
    var body: some View {
        NavigationStack {
            List(booksVM.orderedLatestBooks) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
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
                        await booksVM.getReaded(email: userVM.usuario.email)
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
        let booksVM = BooksViewModel()
        return LatestView()
            .environmentObject(booksVM)
            .environmentObject(userVM)
            .task {
                await booksVM.getBooksLatest()
            }
    }
}
