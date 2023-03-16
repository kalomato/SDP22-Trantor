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
    static let bookTest = Books(summary: "The Time Machine is a science fiction novel by H. G. Wells", author: "H. G. Wells", plot: "The book's protagonist is an English scientist and gentleman inventor living in Richmond...", isbn: "0451528557", year: 1985, id: 1, cover: URL (string: "https://images.gr-assets.com/books/1327942880l/2493.jpg"), title: "The Time Machine",  pages: 118, rating: 3.87, price: 26.97)
    
    static let bookNil = Books(summary: "error", author: "error", plot: "error", isbn: "error", year: 0, id: 0, cover: URL (string: ""), title: "Error al obtener el libro", pages: 0, rating: 0, price: 0)
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

// MARK: - Structs Pedidos
struct Order:Codable, Hashable {
    let estado: String
    let npedido: String
    let date: String
    let books: [Books.ID]
    let email: String
}

extension Order {
    static let orderTest = Order(estado: "recibido", npedido: "CCB8F7E5-1B60-40E4-9514-CD65FE5138E1", date: "2023-02-27T18:45:31Z", books: [810, 338, 873, 1], email: "enrique@tizona.net")
}

//Struct que usaré para mostrar los pedidos en la vista correspondiente.
struct Order2:Codable, Hashable, Identifiable {
    let estado: String
    let npedido: String
    let date: String
    let books: [Books.ID]
    var booksFull: [Books] = []
    let email: String
    var id = UUID()
}

extension Order2 {
    static let bookTest1 = Books(summary: "The Time Machine is a science fiction novel by H. G. Wells", author: "H. G. Wells", plot: "The book's protagonist is an English scientist and gentleman inventor living in Richmond...", isbn: "0451528557", year: 1985, id: 1, cover: URL (string: "https://images.gr-assets.com/books/1327942880l/2493.jpg"), title: "The Time Machine",  pages: 118, rating: 3.87, price: 26.97)
    
    static let bookTest2 = Books(summary: "A Princess of Mars is a science fantasy novel...", author: "Edgar Rice", plot: "John Carter, a Confederate veteran of the American Civil War...", isbn: "0143104888", year: 1912, id: 3, cover: URL (string: "https://images.gr-assets.com/books/1332272118l/40395.jpg"), title: "A Princess of Mars",  pages: 186, rating: 3.8, price: 26.97)
    
    static let bookNA = Books(summary: "No disopnible", author: "No disopnible", plot: "No disopnible", isbn: "No disopnible", year: 0, id: 0, cover: URL (string: ""), title: "Este Título ya no está disopnible",  pages: 0, rating: 0, price: 0)
    
    static let order2Test = Order2(estado: "recibido", npedido: "CCB8F7E5-1B60-40E4-9514-CD65FE5138E1", date: "2023-02-27T18:45:31Z", books: [1, 3], booksFull: [bookTest1, bookTest2], email: "enrique@tizona.net")
    
}

// MARK: - Struct Estado Pedido
struct OrderStatus:Codable, Hashable {
    let estado: String
}

extension OrderStatus {
    static let estadoTest = "recibido"
}

func setupDateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter
}


struct IsReaded:Codable {
    let readed:Bool
}
