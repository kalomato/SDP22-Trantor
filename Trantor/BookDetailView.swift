//
//  BookDetailView.swift
//  Trantor
//
//  Created by Enrique on 19/2/23.
//

import SwiftUI

struct BookDetailView: View {
    @ObservedObject var BookDetailVM:BookDetailViewVM
    
    var body: some View {
        //Text(BookDetailVM.book.title)
        VStack {
            Text(BookDetailVM.book.title)
            Text(BookDetailVM.book.year.description)
            Text(BookDetailVM.book.pages?.description ?? "-")
            Text(BookDetailVM.book.isbn ?? "Sin ISBN")
            Text(BookDetailVM.book.author)
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(BookDetailVM: BookDetailViewVM(book: .bookTest))
    }
}
