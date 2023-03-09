//
//  BuyButton.swift
//  Trantor
//
//  Created by Enrique on 10/3/23.
//

import SwiftUI

struct BuyButton: View {
    var body: some View {
        Button (action: {
            
        })  {
            Image(systemName: "cart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 45)
                .foregroundColor(.blue)
                .padding()
        }
        .background(Color.clear)
    }
}

struct BuyButton_Previews: PreviewProvider {
    static var previews: some View {
        BuyButton()
    }
}
