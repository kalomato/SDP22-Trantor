//
//  OrdersView.swift
//  Trantor
//
//  Created by Enrique on 18/2/23.
//

import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var userVM:UserViewModel
    @EnvironmentObject var booksVM:BooksViewModel
    @EnvironmentObject var ordersVM:OrdersViewModel
    
    @State private var selectedBook: Books?
    @State var isLoading = true
    
    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView()
            } else if ordersVM.orderedOrders.count == 0 {
                Text ("No se encontraron pedidos")
            }
            List(ordersVM.orderedOrders) { order in
                OrderRow(order: order,
                         date: ordersVM.stringDateConverter(string: order.date)!,
                         selectedBook: $selectedBook)
            }
            .navigationTitle("Pedidos")
            .searchable(text: $ordersVM.searchText, prompt: "Buscar en Pedidos") {
                if ordersVM.filterOrders.isEmpty {
                    NoSearchResult()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Ordenar") {
                        ForEach(OrdersViewModel.SortType.allCases, id:\.self) { option in
                            Button {
                                ordersVM.sortType = option
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
            .onAppear {
                isLoading = true
                Task {
                    await ordersVM.getOrders(email: userVM.usuario.email)
                    isLoading = false
                }
            }
            .refreshable {
                await ordersVM.getOrders(email: userVM.usuario.email)
            }
        }
        .sheet(item: $selectedBook) { book in
                    BookDetailView(bookDetailVM: BookDetailViewVM(book: book))
                }
        .alert("ERROR",
               isPresented: $ordersVM.showAlert) {
            Button(action: {}) {
                Text("OK")
            }
        } message: {
            Text(ordersVM.errorMSG)
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static let ordersVM = OrdersViewModel()
    static let userVM = UserViewModel()
    static var previews: some View {
        OrdersView()
            .environmentObject(ordersVM)
            .environmentObject(userVM)
            .task {
                await ordersVM.getOrders(email: "enrique@tizona.net")
            }
    }
}
