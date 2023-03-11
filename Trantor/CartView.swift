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
    
    var body: some View {
        Text("Cesta de la compra")
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}
