//
//  NetworkPersistence.swift
//  Trantor
//
//  Created by Enrique on 14/2/23.
//

import SwiftUI

final class NetworkPersistence {
    static let shared = NetworkPersistence()
    
    //En la misma funcion que recupera libros actualizo campo de autor
    func getBooks() async throws -> [Books] {
        var books = try await queryJSON(request: .request(url: .getBooks), type: [Books].self)
        //recuperamos array autores y los metemos en diccionario para mejorar la búsqueda que haremos posteriormente.
        let authors = try await queryJSON(request: .request(url: .getAuthors), type: [Authors].self)
            .reduce(into: [String: Authors]()) { dict, author in dict[author.id] = author }

        //recorro el array de libros y cambio el author por su valor correspondiente de author.name
        //Si no lo encontrara (situación que no debería ocurrir), el valor books.author se quedaría como está.
        for i in 0..<books.count {
            if let author = authors[books[i].author] {
                books[i].author = author.name
            }
        }
        return books
    }
    
    //A costa de más consultas a la API, garantizo la información volviendo a consultar
    //por si el dato hubiera cambiado cuando se solicita sólo un libro.
    //La API sólo da opción de búsqueda por título, pero no me garantiza un resultado sea único
    //(por ejemplo, título "The fisrt man" y "The fist man in the moon" devolvería dos resultados)
    func getBook(id: Int) async throws -> Books? {
        let result = try await getBooks()
        return result.first(where: { $0.id == id })
    }

    func getBooksLatest() async throws -> [Books] {
        var books = try await queryJSON(request: .request(url: .getBooksLatest), type: [Books].self)
        let authors = try await queryJSON(request: .request(url: .getAuthors), type: [Authors].self)
            .reduce(into: [String: Authors]()) { dict, author in dict[author.id] = author }

        for i in 0..<books.count {
            if let author = authors[books[i].author] {
                books[i].author = author.name
            }
        }
        return books
    }

    
    func getAuthors() async throws -> [Authors] {
        //let (data, _) = try await URLSession.shared.data(from: .getAuthors)
        //return try JSONDecoder().decode([Authors].self, from: data)
        try await queryJSON(request: .request(url: .getAuthors), type: [Authors].self)
    }
    
    func getAuthor(id: String) async throws -> String {
        try await queryJSON(request: .request(url: .getBookAuthor(id: id)), type: String.self)
    }
    
    func getUser(email: String) async throws -> User {
        let userToQuery = UserQuery(email: email)
        return try await queryJSON(request: .request(url: .getUser, method: .post, body: userToQuery), type: User.self)
    }
    
    //Función genérica para peticiones
    func queryJSON<T:Codable>(request:URLRequest,
                              type:T.Type,
                              decoder:JSONDecoder = JSONDecoder(),
                              satusOK:Int = 200) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw APIErrors.nonHTTP }
            if response.statusCode == satusOK {
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw APIErrors.json(error)
                }
            } else {
                throw APIErrors.satus(response.statusCode)
            }
        } catch let error as APIErrors {
            throw error
        } catch {
            throw APIErrors.general(error)
        }
    }

    
}
