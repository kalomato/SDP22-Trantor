//
//  PriceButton.swift
//  Trantor
//
//  Created by Enrique on 9/3/23.
//

import SwiftUI

struct PriceButton: View {
    
    let price:Double
    let color:Color
    
    var body: some View {
        Button(action: {
            // Aquí puedes agregar la acción que quieras que ocurra cuando se presiona el botón
        }) {
            Text("\(price, specifier: "%.2f") €")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                .background(color)
                .cornerRadius(8)
        }
    }
}

struct PriceButton_Previews: PreviewProvider {
    static let price = 29.99
    static let color = Color.gray.opacity(0.9)
    static var previews: some View {
        PriceButton(price: price, color: color)
    }
}
