//
//  NetworkPersistence.swift
//  Trantor
//
//  Created by Enrique on 14/2/23.
//

import SwiftUI

final class NetworkPersistence {
    static let shared = NetworkPersistence()
    
    //En la misma funcion que recupera libros y actualiza campo de autor
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
    //por si el dato hubiera cambiado cuando se solicita sólo un libro (p.e. al visualizar detalle)
    //La API sólo da opción de búsqueda por título, pero no me garantiza un resultado sea único
    //(por ejemplo, título "The fisrt man" y "The fist man in the moon" devolvería dos resultados con la búsqueda "first man")
    func getBook(id: Int) async throws -> Books? {
        let result = try await getBooks()
        return result.first(where: { $0.id == id })
    }

    //Obtiene novedades de libros
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

    //Listado de todos los autores
    func getAuthors() async throws -> [Authors] {
        try await queryJSON(request: .request(url: .getAuthors), type: [Authors].self)
    }

    //Obtiene autor a partir de un id
    func getAuthor(id: String) async throws -> Authors {
        try await queryJSON(request: .request(url: .getBookAuthor(id: id)), type: Authors.self)
    }
    
    //Obtiene usuario a partir de un email
    func getUser(email: String) async throws -> User {
        let userToQuery = UserQuery(email: email)
        return try await queryJSON(request: .request(url: .getUser, method: .post, body: userToQuery), type: User.self)
    }
    
    //Devuelve Bool si libro léido/no leído
    func isReaded(email:String, bookID:Int) async throws -> IsReaded {
        let userReaded = UserReaded(email: email, book: bookID)
        return try await queryJSON(request: .request(url: .isReaded, method: .post, body: userReaded), type: IsReaded.self)
    }
    
    //Devuelve struct con email y array de IDs de libros leídos
    func readedBooks(email: String) async throws -> ReadedBooks {
        let userToQuery = UserQuery(email: email)
        return try await queryJSON(request: .request(url: .readedBooks, method: .post, body: userToQuery), type: ReadedBooks.self)
    }
    
    //Marca libros como leídos/no leídos (tipo togle)
    func markRead(email:String, booksID:[Int]) async throws -> Bool {
        let markReaded = ReadedBooks(books: booksID, email: email)
        return try await queryJSON(request: .request(url: .markRead, method: .post, body: markReaded))
    }
    
    //A partir de un email, obtiene los libros leídos por el usuairo, elimina los duplicados,
    //y devuelve array de libros con autor incluido.
    func getReadedBooks(email: String) async throws -> [Books] {
        let userToQuery = UserQuery(email: email)
        var books = [Books]()
        let readedBooks = try await queryJSON(request: .request(url: .readedBooks, method: .post, body: userToQuery), type: ReadedBooks.self)

        if readedBooks.books.count > 0 {
            let uniqueReadedBooks = Array(Set(readedBooks.books))
            let authors = try await queryJSON(request: .request(url: .getAuthors), type: [Authors].self)
                .reduce(into: [String: Authors]()) { dict, author in dict[author.id] = author }

            for i in 0..<uniqueReadedBooks.count {
                if let bookTemp = try await getBook(id: uniqueReadedBooks[i]) {
                    books.append(bookTemp)
                }
            }

            for i in 0..<books.count {
                if let author = authors[books[i].author] {
                    books[i].author = author.name
                }
            }
        }
        return books
    }
    
    //Obtiene array de pedidos de un usuario a partir de un email
    //Utilizo un struct "orders2" que contiene información adicional de los libros incluidos en el pedido.
    func getOrder(email: String) async throws -> [Order2] {
        let userToQuery = UserQuery(email: email)
        let pedidos = try await queryJSON(request: .request(url: .getOrders, method: .post, body: userToQuery), type: [Order].self)
        //Copio los valores de pedidos:[Orders] a pedidos2:[Orders2]
        var pedidos2 = pedidos.map { order -> Order2 in
            return Order2(estado: order.estado,
                          npedido: order.npedido,
                          date: order.date,
                          books: order.books,
                          booksFull: [],
                          email: order.email)
        }
        //Relleno la propiedad booksFull con los libros referenciados en books
        if pedidos2.count > 0 {
            for i in 0..<pedidos2.count {
                for x in 0..<pedidos2[i].books.count {
                    if let book = try await getBook(id: pedidos2[i].books[x]) {
                        pedidos2[i].booksFull.append(book)
                    } else {
                        // si no se pudo obtener el libro, agregamos un libro "no disponible"
                        pedidos2[i].booksFull.append(Order2.bookNA)
                    }
                }
            }
        }
        return pedidos2
    }
    
    //Función genérica para peticiones con devolución de datos.
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
    
    //Función genérica para peticiones sin devolución de datos.
    func queryJSON(request:URLRequest, statusOK:Int = 200) async throws -> Bool {
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw APIErrors.nonHTTP }
            if response.statusCode == statusOK {
                return true
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
