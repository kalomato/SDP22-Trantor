//
//  OrderRow.swift
//  Trantor
//
//  Created by Enrique on 5/3/23.
//

import SwiftUI

// Creo una clase para almacenar el libro seleecionado más adelante porque haciéndolo con @State var la variable no se cargaba bien en el .sheet en muchas ocasiones (línea 43).
class SelectedBook: ObservableObject {
    @Published var book: Books?
}

struct OrderRow: View {
    let order:Order2
    let date:Date
   
    @State private var showBookDetail = false
    @StateObject private var selectedBook = SelectedBook()
    
    var body: some View {
            VStack(alignment: .leading) {
                Text("Pedido número")
                    .font(.headline)
                Text(order.npedido)
                    .font(.headline)
                Text("Estado: \(order.estado)")
                    .font(.subheadline)
                Text("Fecha de pedido: \(DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short))")
                    .font(.subheadline)
                
                Divider()
                ForEach(order.booksFull, id: \.id) { book in
                    //ordersVM.addTotal(value: book.price)
                    BookRow(book: book)
                        .onTapGesture {
                            selectedBook.book = book
                            showBookDetail = true
                        }
                }
                .sheet(isPresented: $showBookDetail) {
                    if let book = selectedBook.book {
                        BookDetailView(bookDetailVM: BookDetailViewVM(book: book))
                            .overlay(
                                Button(action: { showBookDetail = false }, label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.primary)
                                        .opacity(0.5)
                                })
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            )
                    } else {
                        Text("No se han podido cargar los datos del libro")
                    }
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
    }
}


struct OrderRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderRow(order: .order2Test, date: Date())
            .environmentObject(BooksViewModel())
    }
}
