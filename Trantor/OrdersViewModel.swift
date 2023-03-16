//
//  OrdersViewModel.swift
//  Trantor
//
//  Created by Enrique on 5/3/23.
//

import SwiftUI

final class OrdersViewModel:ObservableObject {
    let persistence = NetworkPersistence.shared
    @EnvironmentObject var userVM:UserViewModel
    @Published var orders:[Order2]      = []
    @Published var searchText           = ""
    @Published var sortType:SortType    = .noSort
    @Published var showAlert            = false
    @Published var errorMSG             = ""
        
    enum SortType:String, CaseIterable {
        case dateAscending     = "Por fecha ascendente"
        case estadoAscending   = "Por estado ascendente"
        case estadoDescending  = "Por estado descendente"
        case npedidoAscending  = "Por núm. pedido asc."
        case npedidoDescending = "Por núm. pedido desc."
        case noSort            = "Por defecto (fecha desc.)"
    }
    
    var filterOrders:[Order2] {
        if searchText.isEmpty {
            return orders.sorted { $0.date > $1.date }
        } else {
            return orders.filter {
                $0.estado.lowercased().contains(searchText.lowercased()) ||
                $0.npedido.lowercased().contains(searchText.lowercased()) ||
                $0.booksFull.contains { $0.title.contains(searchText.lowercased()) } ||
                $0.booksFull.contains { $0.author.contains(searchText.lowercased()) }
            }
        }
    }
    
    var orderedOrders:[Order2] {
        switch sortType {
        case .dateAscending:
            return filterOrders.sorted { $0.date < $1.date }
        case .estadoAscending:
            return filterOrders.sorted { $0.estado < $1.estado }
        case .estadoDescending:
            return filterOrders.sorted { $0.estado > $1.estado }
        case .npedidoAscending:
            return filterOrders.sorted { $0.npedido < $1.npedido }
        case .npedidoDescending:
            return filterOrders.sorted { $0.npedido > $1.npedido }
        case .noSort:
            return filterOrders
        }
    }
        
    
    @MainActor func getOrders(email:String) async {
        do {
            if email.isEmpty || email == "Sin email" {
                return
            }
            orders = try await persistence.getOrder(email: email)
            self.orders = orders
        } catch let error as APIErrors {
            errorMSG = error.description
            showAlert.toggle()
        } catch {
            errorMSG = error.localizedDescription
            showAlert.toggle()
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
        self.orders = []
    }
    
}
