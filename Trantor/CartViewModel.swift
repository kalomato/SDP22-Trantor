//
//  CartViewModel.swift
//  Trantor
//
//  Created by Enrique on 13/3/23.
//

import SwiftUI

final class CartViewModel:ObservableObject {
    let persistence = NetworkPersistence.shared
    
    @Published var pendingOrder:Order?
    @Published var booksIDToShop:[Int] = []
    @Published var booksToShop:[Books] = []
    @Published var orderPlaced         = Order(estado: "", npedido: "", date: "", books: [], email: "")
    @Published var orderPlacedDetails  = Order2(estado: "", npedido: "", date: "", books: [], email: "")
    @Published var showError           = false
    @Published var errorMSG            = ""
    
    func addToCart(bookID:Int) {
        booksIDToShop.append(bookID)
        Task {
            await getBooksToShop(booksID: [bookID])
        }
    }
    
    func isInCart(bookID:Int) -> Bool {
        booksIDToShop.contains(bookID)
    }
    
    func removeFromCart(bookID:Int) {
        if let index = booksIDToShop.firstIndex(where: { $0 == bookID }) {
            booksIDToShop.remove(at: index)
        }
        if let index = booksToShop.firstIndex(where: { $0.id == bookID }) {
            booksToShop.remove(at: index)
        }
    }
    
    func calculateTotal(books:[Books]) -> Double {
        var total:Double = 0
        for book in books {
            total += book.price
        }
        return total
    }
    
    @MainActor func placeOrder(email:String, booksID:[Int]) async {
        do {
            orderPlaced = try await persistence.placeOrder(email: email, booksID: booksID)
            orderPlacedDetails = try await persistence.getConfirmationOrder(npedido: orderPlaced.npedido)
        } catch let error as APIErrors {
            errorMSG = error.description
            showError.toggle()
        } catch {
            errorMSG = error.localizedDescription
            showError.toggle()
        }
    }
    
    @MainActor func getBooksToShop(booksID:[Int]) async {
        do {
            for id in booksID {
                booksToShop.append(try await persistence.getBookFull(id: id)!)
            }
        } catch let error as APIErrors {
            errorMSG = error.description
            showError.toggle()
        } catch {
            errorMSG = error.localizedDescription
            showError.toggle()
        }
    }
    
    func stringDateConverter (string:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: string) {
            return date
        } else {
            return nil
        }
    }
    
    func reset() {
        self.booksToShop.removeAll()
        self.booksIDToShop.removeAll()
    }
}
