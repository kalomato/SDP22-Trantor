//
//  UserViewModel.swift
//  Trantor
//
//  Created by Enrique on 27/2/23.
//

import SwiftUI

final class UserViewModel:ObservableObject {
    let persistence = NetworkPersistence.shared

    @Published var usuario             = User(location: "Sin dirección", name: "Sin usuario", role: "usuario", email: "Sin email")
    @Published var validEmail:Bool     = true
    @Published var validPassword:Bool  = true
    @Published var logged:Bool         = false
    @Published var showError           = false
    @Published var errorMSG            = ""
    
    
    @MainActor func login(email: String, pass: String) async -> Bool {
        do {
            self.usuario = try await persistence.getUser(email: email)
            logged = true
            return true
        } catch let error as APIErrors {
            errorMSG = error.description
            showError.toggle()
        } catch {
            errorMSG = error.localizedDescription
            showError.toggle()
        }
        return false
    }
    
    func validaPassword(_ pass: String) -> Bool {
        pass.count >= 6 ? true: false
    }
    
    func validaEmail(_ email: String) -> Bool {
        let expresionRegular = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicado = NSPredicate(format:"SELF MATCHES %@", expresionRegular)
        return predicado.evaluate(with: email)
    }
    
    func logout() {
        self.usuario = User(location: "Logged out", name: "Logged out", role: "logged out", email: "Logged out")
        self.logged = false
    }
    
}
