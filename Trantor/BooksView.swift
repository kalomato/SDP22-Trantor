//
//  ContentView.swift
//  Trantor
//
//  Created by Enrique on 5/2/23.
//

import SwiftUI

struct BooksView: View {
    @EnvironmentObject var vm:BooksViewModel
    @EnvironmentObject var userVM:UserViewModel
    
    var body: some View {
        NavigationStack {
            List(vm.orderedBooks) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
                }
            }
            .navigationTitle("Todos los Libros")
            .navigationDestination(for: Books.self) { book in
                BookDetailView(bookDetailVM: BookDetailViewVM(book: book))
            }
            .searchable(text: $vm.searchText, prompt: "Buscar en todos los libros") {
                if vm.filterBooks.isEmpty {
                    NoSearchResult()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Ordenar") {
                        ForEach(BooksViewModel.SortType.allCases, id:\.self) { option in
                            Button {
                                vm.sortType = option
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
                await vm.getBooks()
            }
        }
        .alert("ERROR",
               isPresented: $vm.showAlert) {
            Button(action: {}) {
                Text("OK")
            }
        } message: {
            Text(vm.errorMSG)
        }
    }

}


struct BooksView_Previews: PreviewProvider {
    static let vm = BooksViewModel()
    static let userVM = UserViewModel()
    static var previews: some View {
        BooksView()
            //.environmentObject(BooksViewModel())
            .environmentObject(vm)
            .environmentObject(userVM)
            .task {
                await vm.getBooks()
            }
    }
}


