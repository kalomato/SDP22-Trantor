//
//  BuyButton.swift
//  Trantor
//
//  Created by Enrique on 10/3/23.
//

import SwiftUI

struct BuyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .white : .blue)
            .background(configuration.isPressed ? Color.orange : Color.clear)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
//            .onTapGesture {
//                let haptic = UIImpactFeedbackGenerator(style: .medium)
//                haptic.impactOccurred()
//            }
    }
}


struct BuyButton: View {
    @EnvironmentObject var cartVM:CartViewModel
    
    let book:Books
    
    var body: some View {
        Button (action: {
            cartVM.addToCart(bookID: book.id)
        })  {
            Image(systemName: !cartVM.isInCart(bookID: book.id) ? "cart.badge.plus" : "cart.fill.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 45)
                .foregroundColor(.blue)
                .padding()
        }
        .buttonStyle(BuyButtonStyle())
    }
}

struct BuyButton_Previews: PreviewProvider {
    static var previews: some View {
        BuyButton(book: .bookTest)
            .environmentObject(CartViewModel())
    }
}
