//
//  ContentView.swift
//  Trantor
//
//  Created by Enrique on 5/2/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm:BooksViewModel
    
    var body: some View {
        NavigationStack {
            List(vm.books) { book in
                BookRow(book: book)
            }
            .navigationTitle("Libros")
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


struct ContentView_Previews: PreviewProvider {
    static let vm = BooksViewModel()
    static var previews: some View {
        ContentView()
            //.environmentObject(BooksViewModel())
            .environmentObject(vm)
            .task {
                await vm.getBooks()
            }
    }
}


