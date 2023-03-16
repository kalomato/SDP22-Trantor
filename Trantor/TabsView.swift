//
//  TabsTrantor.swift
//  Trantor
//
//  Created by Enrique on 18/2/23.
//

import SwiftUI

struct TabsView: View {
    @EnvironmentObject var userVM:UserViewModel
    @EnvironmentObject var booksVM:BooksViewModel
    @StateObject var readedVM = ReadedViewModel()
    @StateObject var ordersVM = OrdersViewModel()
    @StateObject var cartVM   = CartViewModel()

    var body: some View {
        TabView {
            BooksView()
                .environmentObject(booksVM)
                .environmentObject(userVM)
                .environmentObject(cartVM)
                .environmentObject(readedVM)
                .tabItem {
                    Label("Todos los Libros", systemImage: "book.fill")
                }
            LatestView()
                .environmentObject(booksVM)
                .environmentObject(userVM)
                .environmentObject(cartVM)
                .environmentObject(readedVM)
                .tabItem {
                    Label("Novedades", systemImage: "sparkles")
                }
            ReadedView()
                .environmentObject(booksVM)
                .environmentObject(userVM)
                .environmentObject(readedVM)
                .environmentObject(cartVM)
                .tabItem {
                    Label("Leídos", systemImage: "bookmark.fill")
                }
            OrdersView()
                .environmentObject(userVM)
                .environmentObject(ordersVM)
                .environmentObject(cartVM)
                .tabItem {
                    Label("Historial Pedidos", systemImage: "basket.fill")
                }
            CartView()
                .environmentObject(userVM)
                .environmentObject(booksVM)
                .environmentObject(cartVM)
                .tabItem {
                    Label("Cesta", systemImage: "cart.fill")
                }
                .badge(cartVM.booksIDToShop.count > 0 ? "\(cartVM.booksIDToShop.count)" : nil)
        }
        .navigationBarHidden(true)
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User.userTest
        let userVM = UserViewModel()
        userVM.usuario = user
        return TabsView()
            .environmentObject(BooksViewModel())
            .environmentObject(userVM)
            .environmentObject(ReadedViewModel())
            .environmentObject(OrdersViewModel())
    }
}
