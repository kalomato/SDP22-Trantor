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
    @State var showAlert = false
    @State var alertMsg  = ""
    @State private var isLoading = true
    @State private var firstLoad = true
    
    var body: some View {
        NavigationStack {
            if ordersVM.orderedOrders.count == 0 && !isLoading && ordersVM.searchText.count == 0 {
                Text ("No hay pedidos")
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
                //isLoading = true
                Task {
                    if firstLoad {
                        await ordersVM.getOrders(email: userVM.usuario.email)
                        firstLoad = false
                        isLoading = false
                    }
                }
            }
            .refreshable {
                isLoading = true
                await ordersVM.getOrders(email: userVM.usuario.email)
                isLoading = false
            }
            .overlay {
                if isLoading {
                    LoadingView()
                        .transition(.opacity)
                }
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
