//
//  BookDetailView.swift
//  Trantor
//
//  Created by Enrique on 19/2/23.
//

import SwiftUI

struct BookDetailView: View {
    @ObservedObject var bookDetailVM:BookDetailViewVM
    @State private var isExpandedSummary = false
    @State private var isExpandedPlot = false
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 15) {
                Group {
                    if let cover = bookDetailVM.book.cover {
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
                                    .shadow(color: Color.gray.opacity(0.8), radius: 5, x: 2, y: 2)
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
                    Text(bookDetailVM.book.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text ("PRECIO")
                                .font(.headline)
                            Text("\(bookDetailVM.book.price, specifier: "%.2f")€")
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 10) {
                            Text ("VALORACIÓN")
                                .font(.headline)
                            RatingStars(rating: bookDetailVM.book.rating ?? 0, size: 16)
                        }
                    }
                    Divider()
                }
                Group {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("AUTOR")
                                .font(.headline)
                            Text(bookDetailVM.book.author)
                                .font(.body)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 10) {
                            Text("AÑO")
                                .font(.headline)
                            Text(String(bookDetailVM.book.year))
                                .font(.body)
                        }
                    }
                    Divider()
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ISBN")
                                .font(.headline)
                            Text(bookDetailVM.isbn)
                                .font(.body)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 10) {
                            Text("PÁGINAS")
                                .font(.headline)
                            Text(bookDetailVM.pages)
                                .font(.body)
                        }
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("RESUMEN")
                            .font(.headline)
                        Text(bookDetailVM.summary)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(8)
                            .padding(.bottom, 20)
                            .lineLimit(isExpandedSummary ? nil : 7)
                        HStack {
                            Spacer()
                            if bookDetailVM.summary.count > 260 {
                                Button(action: {
                                    isExpandedSummary.toggle()
                                }, label: {
                                    Text(isExpandedSummary ? "Leer menos" : "Leer más")
                                })
                            }
                        }
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ARGUMENTO")
                            .font(.headline)
                        Text(bookDetailVM.plot)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(8)
                            .padding(.bottom, 20)
                            .lineLimit(isExpandedPlot ? nil : 5)
                        HStack {
                            Spacer()
                            if bookDetailVM.plot.count > 250 {
                                Button(action: {
                                    isExpandedPlot.toggle()
                                }, label: {
                                    Text(isExpandedPlot ? "Leer menos" : "Leer más")
                                })
                            }
                        }
                        
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
    }
}


struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(bookDetailVM: BookDetailViewVM(book: .bookTest))
    }
}
