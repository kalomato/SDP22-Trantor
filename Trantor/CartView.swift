//
//  CartView.swift
//  Trantor
//
//  Created by Enrique on 11/3/23.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var userVM:UserViewModel
    @EnvironmentObject var booksVM:BooksViewModel
    @EnvironmentObject var cartVM:CartViewModel
    
    var body: some View {
        VStack {
            NavigationStack {
                if cartVM.booksIDToShop.isEmpty {
                    CartEmptyView()
                }
                
                List(cartVM.booksToShop) { book in
                    CartBookRow(book: book)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Cesta de la compra")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        UserMenu(user: userVM.usuario)
                    }
                }
                
                if !cartVM.booksIDToShop.isEmpty {
                    ZStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("LIBROS: \(cartVM.booksToShop.count)")
                                    .font(.headline)
                                    .padding(.vertical, 1)
                                Text("IMPORTE TOTAL: \(cartVM.calculateTotal(books: cartVM.booksToShop), specifier: "%.2f") €")
                                    .font(.headline)
                            }
                            Spacer()
                            OrderButton()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .background(Color.yellow.opacity(0.15))
                    .shadow(color: Color.primary.opacity(0.1), radius: 10, x: 0, y: -5)
                }
            }
        }
    }
}


//struct CartView_Previews: PreviewProvider {
//    static var previews: some View {
//        let cartVM = CartViewModel()
//        cartVM.booksIDToShop = [1,1,3]
//        cartVM.booksToShop = [Books.bookTest, Books.bookTest,
//            Books(summary: "A Princess of Mars is a science fantasy novel...", author: "H. G. Wells", plot: "John Carter, a Confederate veteran of the American Civil War...", isbn: "0143104888", year: 1912, id: 3, cover: URL (string: "https://images.gr-assets.com/books/1332272118l/40395.jpg"), title: "A Princess of Mars",  pages: 118, rating: 3.87, price: 26.97)
//        ]
//        return CartView()
//            .environmentObject(cartVM)
//            .environmentObject(UserViewModel())
//            .environmentObject(BooksViewModel())
//    }
//}

#Preview {
    let cartVM = CartViewModel()
    cartVM.booksIDToShop = [1,1,3]
    cartVM.booksToShop = [Books.bookTest, Books.bookTest,
        Books(summary: "A Princess of Mars is a science fantasy novel...", author: "H. G. Wells", plot: "John Carter, a Confederate veteran of the American Civil War...", isbn: "0143104888", year: 1912, id: 3, cover: URL (string: "https://images.gr-assets.com/books/1332272118l/40395.jpg"), title: "A Princess of Mars",  pages: 118, rating: 3.87, price: 26.97)
    ]
    return CartView()
        .environmentObject(cartVM)
        .environmentObject(UserViewModel())
        .environmentObject(BooksViewModel())
}
