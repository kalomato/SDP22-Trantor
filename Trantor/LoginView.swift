//
//  LoginView.swift
//  Trantor
//
//  Created by Enrique Suárez on 27/2/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userVM:UserViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var validEmail = false
    @State private var validPassword = false
    @State private var isLogged = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                Text("Iniciar sesión")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                VStack(spacing: 16) {
                    TextField("Correo electrónico", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Button(action: {
                    validEmail = userVM.validaEmail(email)
                    validPassword = userVM.validaPassword(password)
                    if validEmail && validPassword {
                        userVM.doLogin(email: email, pass: password)
                        print("Usuario correcto")
                        print("Correo: \(userVM.usuario.email)")
                        isLogged = true
                    } else {
                        
                    }
                }) {
                    Text("Iniciar sesión")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                NavigationLink(destination: TabsView(), isActive: $isLogged, label: { EmptyView() })
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
