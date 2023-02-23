//
//  TabsTrantor.swift
//  Trantor
//
//  Created by Enrique on 18/2/23.
//

import SwiftUI

struct TabsView: View {
    var body: some View {
        TabView {
            BooksView()
                .tabItem {
                    Label("Todos los Libros", systemImage: "book.fill")
                }
            LatestView()
                .tabItem {
                    Label("Novedades", systemImage: "sparkles")
                }
            FavoritesView()
                .tabItem {
                    Label("Favoritos", systemImage: "bookmark.fill")
                }
            OrdersView()
                .tabItem {
                    Label("Pedidos", systemImage: "cart.fill")
                }
        }
    }
}

struct TabsTrantor_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
            .environmentObject(BooksViewModel())
            .environmentObject(BooksLatestViewModel())
    }
}
