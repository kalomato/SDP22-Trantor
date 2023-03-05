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
    
//    init(usuario: User) {
//        Task {
//            self.usuario = usuario
//        }
//    }
    
    enum SortType:String, CaseIterable {
        case dateDescending    = "Por fecha descendente"
        case dateAscending     = "Por fecha ascendente"
        case estadoAscending   = "Por estado ascendente"
        case estadoDescending  = "Por estado descendente"
        case npedidoAscending  = "Por núm. pedido ascendente"
        case npedidoDescending = "Por núm. pedido descendente"
        case noSort            = "Por defecto"
    }
    
    var filterOrders:[Order2] {
        if searchText.isEmpty {
            return orders.sorted { $0.date > $1.date }
//            return orders
        } else {
            return orders.filter {
                $0.estado.lowercased().contains(searchText.lowercased()) ||
                $0.npedido.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var orderedOrders:[Order2] {
        switch sortType {
        case .dateAscending:
            return filterOrders.sorted { $0.date < $1.date }
        case .dateDescending:
            return filterOrders.sorted { $0.date > $1.date }
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
    
//    init(email:String) {
//        Task {
//            await getReadedBooks(email:email)
//        }
//    }
    
    
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
    
    func reset() {
        self.orders = []
    }
    
}
