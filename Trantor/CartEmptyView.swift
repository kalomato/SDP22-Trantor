//
//  CartEmptyView.swift
//  Trantor
//
//  Created by Enrique on 13/3/23.
//

import SwiftUI

struct CartEmptyView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "books.vertical.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            Text("La cesta está vacía")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct CartEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        CartEmptyView()
    }
}
