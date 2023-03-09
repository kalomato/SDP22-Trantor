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
    @StateObject var readedVM    = ReadedViewModel()
    //@StateObject var booksVM       = BooksViewModel()
    @StateObject var ordersVM      = OrdersViewModel()
    //@ObservedObject var ordersVM = OrdersViewModel()

    var body: some View {
        TabView {
            BooksView()
                .environmentObject(booksVM)
                .environmentObject(userVM)
                .tabItem {
                    Label("Todos los Libros", systemImage: "book.fill")
                }
            LatestView()
                .environmentObject(booksVM)
                .environmentObject(userVM)
                .tabItem {
                    Label("Novedades", systemImage: "sparkles")
                }
            ReadedView()
                .environmentObject(booksVM)
                .environmentObject(userVM)
                .environmentObject(readedVM)
                .tabItem {
                    Label("Leídos", systemImage: "bookmark.fill")
                }
            OrdersView()
                .environmentObject(userVM)
                .environmentObject(ordersVM)
                .tabItem {
                    Label("Pedidos", systemImage: "basket.fill")
                }
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
