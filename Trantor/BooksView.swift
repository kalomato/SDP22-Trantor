//
//  ContentView.swift
//  Trantor
//
//  Created by Enrique on 5/2/23.
//

import SwiftUI

struct BooksView: View {
    @EnvironmentObject var vm:BooksViewModel
    
    var body: some View {
        NavigationStack {
            List(vm.filterBooks) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
                }
            }
            .navigationTitle("Libros")
            .navigationDestination(for: Books.self) { book in
                BookDetailView(BookDetailVM: BookDetailViewVM(book: book))
            }
            .searchable(text: $vm.search)
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
    static var previews: some View {
        BooksView()
            //.environmentObject(BooksViewModel())
            .environmentObject(vm)
            .task {
                await vm.getBooks()
            }
    }
}


