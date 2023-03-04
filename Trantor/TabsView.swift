//
//  TabsTrantor.swift
//  Trantor
//
//  Created by Enrique on 18/2/23.
//

import SwiftUI

struct TabsView: View {
    @EnvironmentObject var userVM:UserViewModel
    @StateObject var booksVM       = BooksViewModel()
    @StateObject var booksLatestVM = BooksLatestViewModel()
    @StateObject var readedVM      = ReadedViewModel()

    var body: some View {
        TabView {
            BooksView()
                .environmentObject(booksVM)
                .environmentObject(userVM)
                .tabItem {
                    Label("Todos los Libros", systemImage: "book.fill")
                }
            LatestView()
                .environmentObject(booksLatestVM)
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
                .tabItem {
                    Label("Pedidos", systemImage: "cart.fill")
                }
        }
        .navigationBarHidden(true)
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
            .environmentObject(BooksViewModel())
            .environmentObject(BooksLatestViewModel())
            .environmentObject(UserViewModel())
            .environmentObject(ReadedViewModel())
    }
}
