//
//  ModelDefinition.swift
//  Trantor
//
//  Created by Enrique on 5/2/23.
//

import Foundation

// MARK: - Struct Libros
struct TrantorBooks: Codable, Identifiable {
    let summary: String?
    let title: String
    let id: Int
    let author: String
    let pages: Int?
    let cover: URL?
    let plot: String?
    let year: Int
    let isbn: String?
    let rating: Double?
}

//typealias Tbooks = [TrantorBooks]

extension TrantorBooks {
    static let trantorBooksTest = TrantorBooks(summary: "The Time Machine is a science fiction novel by H. G. Wells", title: "The Time Machine", id: 1, author: "531EDFA6-A361-4E15-873F-45E4EA0AF120", pages: 118, cover: URL (string: "https://images.gr-assets.com/books/1327942880l/2493.jpg"), plot: "The book's protagonist is an English scientist and gentleman inventor living in Richmond...", year: 1985, isbn: "0451528557", rating: 3.87)
}

// MARK: - Struct Autores
struct TrantorAuthors: Codable {
    let name, id: String
}

//typealias Tauthors = [TrantorAuthors]

extension TrantorAuthors {
    static let trantorAuthorsTest = TrantorAuthors(name: "H. G. Wells", id: "531EDFA6-A361-4E15-873F-45E4EA0AF120")
}
