//
//  BookRow.swift
//  Trantor
//
//  Created by Enrique on 19/2/23.
//

import SwiftUI

struct BookRow: View {
    let book:Books
    
    var body: some View {
        HStack {
            AsyncImage(url: book.cover) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .cornerRadius(10)
                
            } placeholder: {
                Image(systemName: "text.book.closed.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
            }
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                Text(book.author)
                    .font(.subheadline)
                Text("Año: \(book.year.description)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
        }
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        BookRow(book: .bookTest)
    }
}
