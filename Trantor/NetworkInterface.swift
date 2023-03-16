//
//  NetworkInterface.swift
//  Trantor
//
//  Created by Enrique Suárez on 8/2/23.
//

import Foundation

enum APIErrors:Error {
    case general(Error)
    case json(Error)
    case nonHTTP
    case satus(Int)
    case invalidData
    
    var description:String {
        switch self {
        case .general(let error):
            return "Error General: \(error)"
        case .json(let error):
            return "Error JSON: \(error)"
        case .nonHTTP:
            return "No es conexión HTTP"
        case .satus(let code):
            return "Error estado: Código \(code)"
        case .invalidData:
            return "Datos no válidos."
        }
    }
}

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
    static let bookAPI          = "books"
    static let getBooks         = serverURL.appending(component: "\(bookAPI)").appending(component: "list")             //GET lista completa libros
    static let getBooksLatest   = serverURL.appending(component: "\(bookAPI)").appending(component: "latest")           //GET libros destacados
    static let getAuthors       = serverURL.appending(component: "\(bookAPI)").appending(component: "authors")          //GET listado todos autores

    static func getBookAuthor(id:String) -> URL {                                                                       //GET solicitar autor a partir de id
        serverURL.appending(component: "\(bookAPI)").appending(component: "getAuthor").appending(component: "\(id)")
    }
    
    static func findBook(search:String) -> URL {                                                                        //GET buscar libro por título
        serverURL.appending(component: "\(bookAPI)").appending(component: "find").appending(component: "\(search)")
    }

    //ENDPOINT clientes/usuarios
    static let clientAPI        = "client"
    static let createUser       = serverURL.appending(component: "\(clientAPI)")                                        //POST crear usuario
    static let updateUser       = serverURL.appending(component: "\(clientAPI)")                                        //PUT  actualizar usuario
    static let getUser          = serverURL.appending(component: "\(clientAPI)").appending(component: "query")          //POST información cliente (email)
    static let markRead         = serverURL.appending(component: "\(clientAPI)").appending(component: "readQuery")      //POST marcar leídos libros de usuario
    static let reportBooksUser  = serverURL.appending(component: "\(clientAPI)").appending(component: "reportBooksUser")//POST libros leídos/comprados usuario
    static let readedBooks      = serverURL.appending(component: "\(clientAPI)").appending(component: "readedBooks")    //POST obtener libros leídos usuario
    static let isReaded         = serverURL.appending(component: "\(clientAPI)").appending(component: "isReaded")       //POST libro ¿está leído por usuario?
    
    //ENDPOINT compras
    static let shopAPI           = "shop"
    static let newOrder          = serverURL.appending(component: "\(shopAPI)").appending(component: "newOrder")        //POST nuevo pedido libros usuario
    static let getOrders         = serverURL.appending(component: "\(shopAPI)").appending(component: "orders")          //POST pedidos usuario
    static let modifyOrderStatus = serverURL.appending(component: "\(shopAPI)").appending(component: "orderStatus")     //PUT  modificar estado pedido
    static let allOrders         = serverURL.appending(component: "\(shopAPI)").appending(component: "allOrders")       //PUT  Todos los pedidos
    
    
    static func getOrder(id:String) -> URL {                                                                            //GET solicitar información de un pedido
        serverURL.appending(component: "\(shopAPI)").appending(component: "order").appending(component: "\(id)")
    }
    
    static func orderStatus(id:String) -> URL {                                                                         //GET estado de un pedido
        serverURL.appending(component: "\(shopAPI)").appending(component: "orderStatus").appending(component: "\(id)")
    }
}


extension URLRequest {
    static func request(url:URL, method:HTTPMethod = .get) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    static func request<T:Codable>(url:URL, method:HTTPMethod, body:T) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = try? JSONEncoder().encode(body)
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    static func createUser<T:Codable>(body:T) -> URLRequest {
        request(url: .createUser, method: .post, body: body)
    }

    static func updateteUser<T:Codable>(body:T) -> URLRequest {
        request(url: .updateUser, method: .put, body: body)
    }

    static func getUser<T:Codable>(body:T) -> URLRequest {
        request(url: .getUser, method: .post, body: body)
    }
    
    static func isReaded<T:Codable>(body:T) -> URLRequest {
        request(url: .isReaded, method: .post, body: body)
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

    static func getOrders<T:Codable>(body:T) -> URLRequest {
        request(url: .getOrders, method: .post, body: body)
    }

    static func modifyOrderStatus<T:Codable>(body:T) -> URLRequest {
        request(url: .modifyOrderStatus, method: .put, body: body)
    }

}
