//
//  ModelOperations.swift
//  Trantor
//
//  Created by Enrique on 27/2/23.
//

import Foundation

struct UserQuery:Codable {
    var email:String
}

struct UserReaded:Codable {
    var email:String
    var book:Int
}

struct PlaceOrder:Codable {
    var email:String
    var pedido:[Int]
}
