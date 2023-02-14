//
//  NetworkInterface.swift
//  Trantor
//
//  Created by Enrique Suárez on 8/2/23.
//

import Foundation

enum HTTPMethod:String {
    case get  = "GET"
    case put  = "PUT"
    case post = "POST"
}

let serverURL = URL.productionServer

extension URL {
    //URL Base
    static let productionServer  = URL(string: "https://trantorapi-acacademy.herokuapp.com/api")!
    
    //URLs para los 16 ENDPOINT de la API
    //ENDPOINT libros
    static let getBooks          = serverURL.appending(component: "books/list")              //GET lista completa libros
    static let getBooksLatest    = serverURL.appending(component: "books/latest")            //GET libros destacados
    static let getAuthors        = serverURL.appending(component: "books/authors")           //GET listado todos autores

    static func getBookAuthor(id:String) -> URL {                                            //GET solicitar autor a partir de id de autor
        serverURL.appending(component: "books/getAuthor/\(id)")
    }
    
    static func findBook(search:String) -> URL {                                             //GET buscar libro por título
        serverURL.appending(component: "books/find/\(search)")
    }

    //ENDPOINT clientes/usuarios
    static let createUser        = serverURL.appending(component: "client")                  //POST crear usuario
    static let updateUser        = serverURL.appending(component: "client")                  //PUT  actualizar usuario
    static let infoUser          = serverURL.appending(component: "client/query")            //POST información cliente (email)
    static let markRead          = serverURL.appending(component: "client/readQuery")        //POST marcar leídos libros de usuario
    static let reportBooksUser   = serverURL.appending(component: "client/reportBooks/User") //POST libros leídos/comprados usuario
    static let readedBooks       = serverURL.appending(component: "client/readedBooks")      //POST libros leídos usuario

    //ENDPOINT compras
    static let newOrder          = serverURL.appending(component: "shop/newOrder")           //POST nuevo pedido libros usuario
    static let orders            = serverURL.appending(component: "shop/orders")             //POST pedidos usuario
    static let modifyOrderStatus = serverURL.appending(component: "shop/orderStatus")        //PUT  modificar estado pedido
    
    
    static func orderInfo(id:String) -> URL {                                                //GET solicitar información de un pedido
        serverURL.appending(component: "shop/order/\(id)")
    }
    
    static func orderStatus(id:String) -> URL {                                              //GET estado de un pedido
        serverURL.appending(component: "shop/orderStatus/\(id)")
    }
}


extension URLRequest {
    static func request<T:Codable>(url:URL, method:HTTPMethod, body:T) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = try? JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    static func createUser<T:Codable>(body:T) -> URLRequest {
        request(url: .createUser, method: .post, body: body)
    }

    static func updateteUser<T:Codable>(body:T) -> URLRequest {
        request(url: .updateUser, method: .put, body: body)
    }

    static func infoUser<T:Codable>(body:T) -> URLRequest {
        request(url: .infoUser, method: .post, body: body)
    }

    static func markRead<T:Codable>(body:T) -> URLRequest {
        request(url: .markRead, method: .post, body: body)
    }

    static func reportBooksUser<T:Codable>(body:T) -> URLRequest {
        request(url: .reportBooksUser, method: .post, body: body)
    }

    static func readedBooks<T:Codable>(body:T) -> URLRequest {
        request(url: .readedBooks, method: .post, body: body)
    }

    static func newOrder<T:Codable>(body:T) -> URLRequest {
        request(url: .newOrder, method: .post, body: body)
    }

    static func orders<T:Codable>(body:T) -> URLRequest {
        request(url: .orders, method: .post, body: body)
    }

    static func modifyOrderStatus<T:Codable>(body:T) -> URLRequest {
        request(url: .modifyOrderStatus, method: .put, body: body)
    }

}
