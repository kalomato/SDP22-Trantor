//
//  LatestView.swift
//  Trantor
//
//  Created by Enrique on 18/2/23.
//

import SwiftUI

struct LatestView: View {
    @EnvironmentObject var booksLatestVM:BooksLatestViewModel
    @EnvironmentObject var userVM:UserViewModel
    
    var body: some View {
        NavigationStack {
            List(booksLatestVM.orderedLatestBooks) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
                }
            }
            .navigationTitle("Novedades")
            .navigationDestination(for: Books.self) { book in
                BookDetailView(bookDetailVM: BookDetailViewVM(book: book))
            }
            .searchable(text: $booksLatestVM.searchText, prompt: "Buscar en novedades") {
                if booksLatestVM.filterLatestBooks.isEmpty {
                    NoSearchResult()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Ordenar") {
                        ForEach(BooksLatestViewModel.SortType.allCases, id:\.self) { option in
                            Button {
                                booksLatestVM.sortType = option
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
                await booksLatestVM.getBooksLatest()
            }
        }
        .alert("ERROR",
               isPresented: $booksLatestVM.showAlert) {
            Button(action: {}) {
                Text("OK")
            }
        } message: {
            Text(booksLatestVM.errorMSG)
        }
    }
}


struct LatestView_Previews: PreviewProvider {
    static let booksLatestVM = BooksLatestViewModel()
    static let userVM = UserViewModel()
    static var previews: some View {
        LatestView()
            .environmentObject(booksLatestVM)
            .environmentObject(userVM)
            .task {
                await booksLatestVM.getBooksLatest()
            }
    }
}
