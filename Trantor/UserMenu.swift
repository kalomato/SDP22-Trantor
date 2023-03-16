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
    
    var body: some View {
        Menu {
            Button {
                booksVM.reset()
                userVM.logout()
            } label: {
                Text("Cerrar sesión")
                Image(systemName: "arrowshape.turn.up.left.circle")
            }
        } label: {
            Image(systemName: "person.circle")
        }
    }
}


struct UserMenu_Previews: PreviewProvider {
    static var previews: some View {
        UserMenu(user: .userTest)
            .environmentObject(UserViewModel())
            .environmentObject(BooksViewModel())
    }
}
