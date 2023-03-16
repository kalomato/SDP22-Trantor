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
    @EnvironmentObject var cartVM:CartViewModel
    
    @State private var isLoading = true
    @State private var firstLoad = true
    @State var showAlert = false
    @State var alertMsg  = ""
    
    var body: some View {
        NavigationStack {
            if ordersVM.orderedOrders.count == 0 && !isLoading && ordersVM.searchText.count == 0 {
                Text ("No hay pedidos de \(userVM.usuario.name)")
            }
            List(ordersVM.orderedOrders) { order in
                OrderRow(order: order,
                         date: ordersVM.stringDateConverter(string: order.date)!)
            }
            .navigationTitle("Pedidos")
            .searchable(text: $ordersVM.searchText, prompt: "Buscar en Pedidos") {
                if ordersVM.filterOrders.isEmpty {
                    NoSearchResult()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(OrdersViewModel.SortType.allCases, id:\.self) { option in
                            Button {
                                ordersVM.sortType = option
                            } label: {
                                Text(option.rawValue)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    UserMenu(user: userVM.usuario)
                }
            }
            .onAppear {
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
    static var previews: some View {
        let user = User(location: "Mi casa", name: "Enrique", role: "user", email: "enrique@tizona.net")
        let userVM = UserViewModel()
        userVM.usuario = user
        return OrdersView()
            .environmentObject(OrdersViewModel())
            .environmentObject(userVM)
            .environmentObject(BooksViewModel())
            .task {
                await OrdersViewModel().getOrders(email: "enrique@tizona.net")
            }
    }
}
