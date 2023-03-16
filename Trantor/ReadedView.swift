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
    @EnvironmentObject var cartVM:CartViewModel
    
    @State var showAlert = false
    @State var alertMsg  = ""
    @State private var isLoading     = true
    @State private var firstLoad     = true
    @State private var scale:CGFloat = 0.9
    
    var body: some View {
        NavigationStack {
            if readedVM.orderedReadedBooks.count == 0 && !isLoading && readedVM.searchText.count == 0 {
                Text ("No hay libros leídos por \(userVM.usuario.name)")
            }
            List(readedVM.orderedReadedBooks) { book in
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
                    Menu {
                        ForEach(ReadedViewModel.SortType.allCases, id:\.self) { option in
                            Button {
                                readedVM.sortType = option
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
            .onAppear {
                if firstLoad {
                    Task {
                        await readedVM.getReadedBooks(email: userVM.usuario.email)
                        isLoading = false
                        firstLoad = false
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
    static var previews: some View {
        ReadedView()
            .environmentObject(ReadedViewModel())
            .environmentObject(UserViewModel())
            .environmentObject(BooksViewModel())
            .task {
                await ReadedViewModel().getReadedBooks(email: "enrique@tizona.net")
            }
    }
}
