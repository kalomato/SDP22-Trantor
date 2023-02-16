//
//  NetworkTest.swift
//  Trantor
//
//  Created by Enrique Suárez on 16/2/23.
//

import SwiftUI

//falta funcion getBooksTest()

func getBooksData() -> [Books] {
    guard let url = Bundle.main.url(forResource: "trantorBooksTest", withExtension: "json") else { return [] }
    do {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Books].self, from: data)
    } catch {
        print("Error \(error)")
        return []
    }
}

