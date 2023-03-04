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
    var author: String
    let plot:String?
    let isbn:String?
    let year:Int
    let id:Int
    let cover: URL?
    let title: String
    let pages: Int?
    let rating: Double?
    let price: Double
}

extension Books {
    static let bookTest = Books(summary: "The Time Machine is a science fiction novel by H. G. Wells", author: "531EDFA6-A361-4E15-873F-45E4EA0AF120", plot: "The book's protagonist is an English scientist and gentleman inventor living in Richmond...", isbn: "0451528557", year: 1985, id: 1, cover: URL (string: "https://images.gr-assets.com/books/1327942880l/2493.jpg"), title: "The Time Machine",  pages: 118, rating: 3.87, price: 26.97)
}

// MARK: - Struct Autores
struct Authors: Codable, Identifiable, Hashable {
    let name, id: String
}

extension Authors {
    static let authorTest = Authors(name: "H. G. Wells", id: "531EDFA6-A361-4E15-873F-45E4EA0AF120")
}

// MARK: - Struct Usuario
struct User:Codable, Hashable {
    let location: String
    let name: String
    let role: String
    let email: String
}

extension User {
    static let userTest = User(location: "Home test", name: "User Test", role: "usuario", email: "enrique@tizona.net")
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
    let books: [Books.ID]
    let email: String
//    var id: UUID = UUID()
}

extension ReadedBooks {
    static let booksTest  = [566, 626]
    static let emailTest  = "enrique@tizona.net"
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
