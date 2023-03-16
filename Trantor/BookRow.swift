//
//  BookRow.swift
//  Trantor
//
//  Created by Enrique on 19/2/23.
//

import SwiftUI

struct BookRow: View {
    @EnvironmentObject var booksVM:BooksViewModel
    
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
                    if booksVM.readedBooks.books.contains(book.id) {
                        Image(systemName: "bookmark.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                            .foregroundColor(.green)
                            .opacity(0.8)
                            .padding(.trailing)
                    }
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


struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        return BookRow(book: .bookTest)
            .environmentObject(BooksViewModel())
    }
}
