//
//  UserViewModel.swift
//  Trantor
//
//  Created by Enrique on 27/2/23.
//

import SwiftUI

final class UserViewModel:ObservableObject {
    let persistence = NetworkPersistence.shared
    @Published var user:User
    @Published var showError        = false
    @Published var errorMSG         = ""
    
    init() {
        Task {
            await getUser()
        }
    }
    
    @MainActor func getUser() async {
        do {
            let _    = try await persistence.getUser(email: user.email)
        } catch let error as APIErrors {
            errorMSG = error.description
            showError.toggle()
        } catch {
            errorMSG = error.localizedDescription
            showError.toggle()
        }
    }
}
