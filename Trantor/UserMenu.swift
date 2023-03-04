//
//  UserMenu.swift
//  Trantor
//
//  Created by Enrique Suárez on 2/3/23.
//

import SwiftUI

struct UserMenu: View {
    let user:User
    @EnvironmentObject var userVM:UserViewModel
    @EnvironmentObject var booksVM:BooksViewModel
    @EnvironmentObject var latestVM:BooksLatestViewModel
    
    var body: some View {
        Menu(user.email) {
            Button {
                booksVM.reset()
                latestVM.reset()
                userVM.logout()
            } label: {
                Text("Cerrar sesión")
            }
        }
    }
}

struct UserMenu_Previews: PreviewProvider {
    static var previews: some View {
        UserMenu(user: .userTest)
            .environmentObject(UserViewModel())
    }
}
