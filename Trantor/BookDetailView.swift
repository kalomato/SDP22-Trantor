//
//  BookDetailView.swift
//  Trantor
//
//  Created by Enrique on 19/2/23.
//

import SwiftUI

struct BookDetailView: View {
    @EnvironmentObject var booksVM:BooksViewModel
    @EnvironmentObject var userVM:UserViewModel
    @EnvironmentObject var cartVM:CartViewModel
    @EnvironmentObject var readedVM:ReadedViewModel
    
    @ObservedObject var bookDetailVM:BookDetailViewVM
    
    @State var showAlert                 = false
    @State var alertMsg                  = ""
    @State private var isExpandedSummary = false
    @State private var isExpandedPlot    = false
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 15) {
                Group {
                    Text(bookDetailVM.book.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        if let cover = bookDetailVM.book.cover {
                            AsyncImage(url: cover) { phase in
                                switch phase {
                                case .empty: ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150)
                                        .cornerRadius(10)
                                        .padding(.bottom, 10)
                                        .shadow(color: Color.gray.opacity(0.8), radius: 5, x: 2, y: 2)
                                case .failure:
                                    Image(systemName: "text.book.closed.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150)
                                        .cornerRadius(10)
                                        .padding(.bottom, 10)
                                default: EmptyView()
                                }
                            }
                        }
                        Spacer()
                        VStack (alignment: .trailing) {
                            Text(bookDetailVM.book.author)
                                .font(.title)
                                .italic()
                            Spacer()
                            HStack {
                                Button(action: {
                                    Task {
                                        if (await booksVM.toggleReaded(email: userVM.usuario.email, bookID: [bookDetailVM.book.id])) {
                                            await booksVM.getReaded(email: userVM.usuario.email)
                                            await readedVM.getReadedBooks(email: userVM.usuario.email)
                                        } else {
                                              showAlert = true
                                                alertMsg = "Error, intente de nuevo"
                                        }
                                        
                                    }
                                }) {
                                    ReadedIcon(readed: booksVM.readedBooks.books.contains(bookDetailVM.book.id))
                                }
                                BuyButton(book: bookDetailVM.book)
                            }
                            Spacer()
                            PriceButton(price: bookDetailVM.book.price, color: Color.orange)
                                .padding(.bottom,10)
                            RatingStars(rating: bookDetailVM.book.rating ?? 0, size: 16)
                                .padding(.bottom, 10)
                        }
                    }
                    
                    Divider()
                }
                Group {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ISBN")
                                .font(.headline)
                            Text(bookDetailVM.isbn)
                                .font(.body)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 10) {
                            Text("AÑO")
                                .font(.headline)
                            Text(String(bookDetailVM.book.year))
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
        .onAppear {
            Task {
                do {
                    await booksVM.getReaded(email: userVM.usuario.email)
                }
            }
        }
    }
}


//struct BookDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let user = User(location: "Mi casa", name: "Enrique", role: "user", email: "enrique@tizona.net")
//        let userVM = UserViewModel()
//        userVM.usuario = user
//        return BookDetailView(bookDetailVM: BookDetailViewVM(book: .bookTest))
//            .environmentObject(BooksViewModel())
//            .environmentObject(userVM)
//            .environmentObject(CartViewModel())
//            .environmentObject(ReadedViewModel())
//    }
//}

#Preview {
    let user = User(location: "Mi casa", name: "Enrique", role: "user", email: "enrique@tizona.net")
    let userVM = UserViewModel()
    userVM.usuario = user
    return BookDetailView(bookDetailVM: BookDetailViewVM(book: .bookTest))
        .environmentObject(BooksViewModel())
        .environmentObject(userVM)
        .environmentObject(CartViewModel())
        .environmentObject(ReadedViewModel())
}
