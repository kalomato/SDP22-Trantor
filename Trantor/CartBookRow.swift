//
//  CartBookRow.swift
//  Trantor
//
//  Created by Enrique on 13/3/23.
//

import SwiftUI

struct CartBookRow: View {
    @EnvironmentObject var cartVM:CartViewModel
    
    let book:Books
    static let color = Color.gray.opacity(0.8)
    
    var body: some View {
        HStack {
            AsyncImage(url: book.cover) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .cornerRadius(10)
                    .shadow(color: Color.gray.opacity(0.8), radius: 5, x: 2, y: 2)
                
            } placeholder: {
                Image(systemName: "text.book.closed.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)
                        Text(book.author)
                            .font(.subheadline)
                        Text("Año: \(book.year.description)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button (action: {
                        cartVM.removeFromCart(bookID: book.id)
                    })  {
                        Image(systemName: "trash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                            .foregroundColor(.red)
                            .padding()
                    }
                    .buttonStyle(BuyButtonStyle())
                }
                HStack {
                    RatingStars(rating: book.rating ?? 0, size: 12)
                    Spacer()
                    Text("\(book.price, specifier: "%.2f") €")
                        .font(.title3)
                }
            }
        }
    }
}


struct CartBookRow_Previews: PreviewProvider {
    static var previews: some View {
        CartBookRow(book: .bookTest)
            .environmentObject(CartViewModel())
    }
}
