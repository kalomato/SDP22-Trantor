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
    @EnvironmentObject var cartVM:CartViewModel
    @EnvironmentObject var readedVM:ReadedViewModel
    @State private var firstLoad = true
    @State var showAlert = false
    @State var alertMsg  = ""
    
    var body: some View {
        NavigationStack {
            List(booksVM.orderedLatestBooks) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            CommonSwipeActions.swipeActions(book: book, booksVM: booksVM, userVM: userVM, cartVM: cartVM, readedVM: readedVM)
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
                    Menu {
                        ForEach(BooksViewModel.SortType.allCases, id:\.self) { option in
                            Button {
                                booksVM.sortType = option
                            } label: {
                                Text(option.rawValue)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
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
                    if firstLoad {
                        await booksVM.getBooksLatest()
                        firstLoad = false
                    }
                    await booksVM.getReaded(email: userVM.usuario.email)
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
            .environmentObject(CartViewModel())
            .environmentObject(ReadedViewModel())
            .task {
                await BooksViewModel().getBooksLatest()
            }
    }
}
