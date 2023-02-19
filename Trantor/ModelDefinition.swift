//
//  ModelDefinition.swift
//  Trantor
//
//  Created by Enrique on 5/2/23.
//

import Foundation

// MARK: - Struct Libros
struct Books: Codable, Identifiable, Hashable {
    let summary: String?
    let author: String
    let plot:String?
    let isbn:String?
    let year:Int
    let id:Int
    let cover: URL?
    let title: String
    let pages: Int?
    let rating: Double?
    
//    init(summary: String? = "Sumario no disponible", title: String, id: Int, author: String, pages: Int? = 0, cover: URL? = URL (string: "https://s.gr-assets.com/assets/nophoto/book/111x148-bcc042a9c91a29c1d680899eff700a03.png"), plot: String? = "Argumento no disponible", year: Int, isbn: String? = "ISBN no disponible", rating: Double? = 0.0) {
//            self.summary = summary
//            self.title = title
//            self.id = id
//            self.author = author
//            self.pages = pages
//            self.cover = cover
//            self.plot = plot
//            self.year = year
//            self.isbn = isbn
//            self.rating = rating
//        }
    
    init(summary: String? = "Sumario no disponible", title: String, id: Int, author: String, pages: Int? = 0, cover: URL? = nil, plot: String? = "Argumento no disponible", year: Int, isbn: String? = "ISBN no disponible", rating: Double? = 0.0) {
            self.summary = summary
            self.title = title
            self.id = id
            self.author = author
            self.pages = pages
            self.cover = cover
            self.plot = plot
            self.year = year
            self.isbn = isbn
            self.rating = rating
        }

}


extension Books {
    static let bookTest = Books(summary: "The Time Machine is a science fiction novel by H. G. Wells", title: "The Time Machine", id: 1, author: "531EDFA6-A361-4E15-873F-45E4EA0AF120", pages: 118, cover: URL (string: "https://images.gr-assets.com/books/1327942880l/2493.jpg"), plot: "The book's protagonist is an English scientist and gentleman inventor living in Richmond...", year: 1985, isbn: "0451528557", rating: 3.87)
}

// MARK: - Struct Autores
struct Authors: Codable, Identifiable, Hashable {
    let name, id: String
}


extension Authors {
    static let authorTest = Authors(name: "H. G. Wells", id: "531EDFA6-A361-4E15-873F-45E4EA0AF120")
}

// MARK: - Struct Cliente
struct Client:Codable, Hashable {
    let location: String
    let name: String
    let role: String
    let email: String
    
    init (location:String, name:String, role:String = "user", email:String) {
        self.location = location
        self.name = name
        self.role = role
        self.email = email
    }
}

extension Client {
    static let locationTest = "Mi casa"
    static let nameTest     = "Enrique Suárez Pérez"
    static let roleTest     = "user"
    static let rmailTest    = "enrique@tizona.net"
}

// MARK: - Struct Libros Leídos/Comprados
struct OrderedReadedBooks:Codable, Hashable {
    let ordered: [Books.ID]
    let readed: [Books.ID]
    let email: String
}

extension OrderedReadedBooks {
    static let orderedTest = [566, 626]
    static let readedTest  = [338, 873]
    static let emailTest   = "enrique@tizona.net"
}

// MARK: - Struct Libros Leídos
struct ReadedBooks:Codable, Hashable {
    let readed: [Books.ID]
    let email: String
}

extension ReadedBooks {
    static let readedTest = [566, 626]
    static let email      = "enrique@tizona.net"
}

// MARK: - Struct Nuevo Pedido
struct Order:Codable, Hashable {
    let estado: String
    let npedido: String
    let date: Date
    let books: [Books.ID]
    let email: String
}

extension Order {
    static let estadoTest = "recibido"
    static let npedidoTest = "A5828CC2-DCCE-496F-9E69-722E385A99A1"
    static let emailTest = "enrique@tizona.net"
    static let booksTest = [338, 873]
}

// MARK: - Struct Estado Pedido
struct OrderStatus:Codable, Hashable {
    let estado: String
}

extension OrderStatus {
    static let estadoTest = "recibido"
}
