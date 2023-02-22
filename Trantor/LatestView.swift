//
//  LatestView.swift
//  Trantor
//
//  Created by Enrique on 18/2/23.
//

import SwiftUI

struct LatestView: View {
    @EnvironmentObject var vm:BooksLatestViewModel
    
    var body: some View {
        NavigationStack {
            List(vm.booksLatest) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
                }
            }
            .navigationTitle("Novedades")
            .navigationDestination(for: Books.self) { book in
                BookDetailView(BookDetailVM: BookDetailViewVM(book: book))
            }
            .refreshable {
                await vm.getBooksLatest()
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


struct LatestView_Previews: PreviewProvider {
    static let vm2 = BooksLatestViewModel()
    static var previews: some View {
        LatestView()
            .environmentObject(vm2)
            .task {
                await vm2.getBooksLatest()
            }
    }
}
