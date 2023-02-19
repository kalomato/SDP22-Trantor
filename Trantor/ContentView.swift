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
                HStack {
                    AsyncImage(url: book.cover) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                        
                    } placeholder: {
                        Image(systemName: "text.book.closed.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                    }
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)
                        Text("\(book.year.description)")
                            .font(.caption)
                    }

                }
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
    static var previews: some View {
        ContentView()
            .environmentObject(BooksViewModel())
    }
}
