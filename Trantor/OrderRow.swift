//
//  OrderRow.swift
//  Trantor
//
//  Created by Enrique on 5/3/23.
//

import SwiftUI

struct OrderRow: View {
    let order:Order2
    let date:Date
    @Binding var selectedBook: Books?
    
    @State private var showSheet = false
    
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
                    //Button(action: {
                    //    selectedBook = book
                    //}) {
                        BookRow(book: book) //, selectedBook: $selectedBook)
                            .sheet(item: $selectedBook) { book in
                                BookDetailView(bookDetailVM: BookDetailViewVM(book: book))
                            }
                    //}
                }

            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
        }

}


struct OrderRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderRow(order: .order2Test, date: Date(), selectedBook: .constant(.bookTest))
    }
}
