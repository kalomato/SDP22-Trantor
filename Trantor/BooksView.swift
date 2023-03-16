//
//  ContentView.swift
//  Trantor
//
//  Created by Enrique on 5/2/23.
//

import SwiftUI

struct BooksView: View {
    @EnvironmentObject var userVM:UserViewModel
    @EnvironmentObject var booksVM:BooksViewModel
    @EnvironmentObject var cartVM:CartViewModel
    @EnvironmentObject var readedVM:ReadedViewModel
    
    @State private var firstLoad = true
    @State private var scale: CGFloat = 0.9

    var body: some View {
        NavigationStack {
            List(booksVM.orderedBooks) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            CommonSwipeActions.swipeActions(book: book, booksVM: booksVM, userVM: userVM, cartVM: cartVM, readedVM: readedVM)
                        }
                        .scaleEffect(scale)
                        .onAppear {
                            withAnimation(.spring()) {
                                scale = 1
                            }
                        }
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
                await booksVM.getBooks()
            }
            .onAppear {
                Task {
                    if firstLoad {
                        await booksVM.getBooks()
                        firstLoad = false
                    }
                    await booksVM.getReaded(email: userVM.usuario.email)
                }
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
    static var previews: some View {
        let user = User.userTest
        let userVM = UserViewModel()
        userVM.usuario = user
        return BooksView()
            .environmentObject(BooksViewModel())
            .environmentObject(userVM)
            .environmentObject(CartViewModel())
            .environmentObject(ReadedViewModel())
            .task {
                await BooksViewModel().getBooks()
            }
    }
}
