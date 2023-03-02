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
    var body: some View {
//        Button {
//            ()
//        } label: {
//            Text (user.name)
//        }
        Menu(user.name) {
            Button {
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
