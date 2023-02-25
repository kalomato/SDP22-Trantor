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
            List(vm.orderedLatestBooks) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
                }
            }
            .navigationTitle("Novedades")
            .navigationDestination(for: Books.self) { book in
                BookDetailView(bookDetailVM: BookDetailViewVM(book: book))
            }
            .searchable(text: $vm.searchText, prompt: "Buscar en novedades") {
                if vm.filterLatestBooks.isEmpty {
                    NoSearchResult()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Ordenar") {
                        ForEach(BooksLatestViewModel.SortType.allCases, id:\.self) { option in
                            Button {
                                vm.sortType = option
                            } label: {
                                Text(option.rawValue)
                            }
                        }
                    }
                }
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
