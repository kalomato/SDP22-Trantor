//
//  OrderConfirmView.swift
//  Trantor
//
//  Created by Enrique on 14/3/23.
//

import SwiftUI

struct OrderConfirmView: View {
    @EnvironmentObject var userVM:UserViewModel
    @EnvironmentObject var booksVM:BooksViewModel
    @EnvironmentObject var cartVM:CartViewModel
    
    let order:Order2
    
    var body: some View {
        List {
            Text("PEDIDO REALIZADO")
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .font(.title)
                .foregroundColor(.green)
                .bold()
            
            VStack(alignment: .leading) {
                Text("Pedido número")
                    .font(.headline)
                Text(order.npedido)
                    .font(.headline)
                Text("Estado: \(order.estado)")
                    .font(.subheadline)
                Text("Fecha de pedido: \(DateFormatter.localizedString(from: cartVM.stringDateConverter(string: order.date)!, dateStyle: .short, timeStyle: .short))")
                    .font(.subheadline)
                
                Divider()
                ForEach(order.booksFull, id: \.id) { book in
                    BookRow(book: book)
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            Text("Recibirá un correo electrónico con la información de este pedido.\n\nTambién puede consultarlo en la pestaña de Historial de Pedidos deslizando hacia abajo para actualizar los datos si es necesario")
                .font(.footnote)
                .multilineTextAlignment(.center)
        }
    }
}

//struct OrderConfirmView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderConfirmView(order: Order2.order2Test)
//            .environmentObject(CartViewModel())
//            .environmentObject(BooksViewModel())
//    }
//}

#Preview {
    OrderConfirmView(order: Order2.order2Test)
        .environmentObject(CartViewModel())
        .environmentObject(BooksViewModel())
}
