//
//  BookDetailView.swift
//  Trantor
//
//  Created by Enrique on 19/2/23.
//

import SwiftUI

struct BookDetailView: View {
    @ObservedObject var BookDetailVM:BookDetailViewVM
    @State private var isExpandedSummary = false
    @State private var isExpandedPlot = false
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 15) {
                if let cover = BookDetailVM.book.cover {
                    AsyncImage(url: cover) { phase in
                        switch phase {
                        case .empty: ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 300)
                                .cornerRadius(10)
                                .padding(.bottom, 20)
                        case .failure:
                            Image(systemName: "text.book.closed.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 300)
                                .cornerRadius(10)
                                .padding(.bottom, 20)
                        default: EmptyView()
                        }
                    }
                }
                Text(BookDetailVM.book.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Divider()
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("AUTOR")
                            .font(.headline)
                        Text(BookDetailVM.book.author)
                            .font(.body)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        Text("AÑO")
                            .font(.headline)
                        Text(String(BookDetailVM.book.year))
                            .font(.body)
                    }
                }
                Divider()
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ISBN")
                            .font(.headline)
                        Text(BookDetailVM.isbn)
                            .font(.body)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        Text("PÁGINAS")
                            .font(.headline)
                        Text(BookDetailVM.pages)
                            .font(.body)
                    }
                }

                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    Text("RESUMEN")
                        .font(.headline)
                    Text(BookDetailVM.summary)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(8)
                        .padding(.bottom, 20)
                        .lineLimit(isExpandedSummary ? nil : 7)
                    HStack {
                        Spacer()
                        Button(action: {
                            isExpandedSummary.toggle()
                        }, label: {
                            Text(isExpandedSummary ? "Leer menos" : "Leer más")
                    })
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("ARGUMENTO")
                        .font(.headline)
                    Text(BookDetailVM.plot)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(8)
                        .padding(.bottom, 20)
                        .lineLimit(isExpandedPlot ? nil : 7)
                    HStack {
                        Spacer()
                        Button(action: {
                            isExpandedPlot.toggle()
                        }, label: {
                            Text(isExpandedPlot ? "Leer menos" : "Leer más")
                    })
                    }
                    
                }
                
                
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("VALORACIÓN")
//                        .font(.headline)
//                    Text(String(format: "%.1f", BookDetailVM.rating))
//                        .font(.body)
//                }

            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
                
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(BookDetailVM: BookDetailViewVM(book: .bookTest))
    }
}
