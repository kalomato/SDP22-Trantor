//
//  TabsTrantor.swift
//  Trantor
//
//  Created by Enrique on 18/2/23.
//

import SwiftUI

struct TabsView: View {
    @StateObject var booksVM = BooksViewModel()
    @StateObject var booksLatestVM = BooksLatestViewModel()
    @EnvironmentObject var userVM:UserViewModel
    //@StateObject var userVM = UserViewModel()
    
    var body: some View {
        TabView {
            BooksView()
                .environmentObject(booksVM)
                .tabItem {
                    Label("Todos los Libros", systemImage: "book.fill")
                }
            LatestView()
                .environmentObject(booksLatestVM)
                .tabItem {
                    Label("Novedades", systemImage: "sparkles")
                }
            ReadedView()
                .tabItem {
                    Label("Leídos", systemImage: "bookmark.fill")
                }
            OrdersView()
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
    }
}
