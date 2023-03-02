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
    
    @State var showError    = false
    @State var errorMSG     = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.badge.key.fill")
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
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                
                Button(action: {
                    validEmail = userVM.validaEmail(email)
                    validPassword = userVM.validaPassword(password)
                    if validEmail && validPassword {
                        Task {
                            isLogged = await userVM.login(email: email, pass: password)
                            if !isLogged {
                                errorMSG = "Autenticación incorrecta"
                                showError = true
                            }
                        }
                    } else {
                        errorMSG = ""
                        validEmail ? () : (errorMSG += "Formato de correo incorrecto. \n")
                        validPassword ? () : (errorMSG += "Contraseña demasiado corta. \n")
                        showError = true
                    }
                }) {
                    Text("Iniciar sesión")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                NavigationLink(destination: TabsView().environmentObject(userVM), isActive: $isLogged, label: { EmptyView() })
//                NavigationLink {
//                    if isLogged {
//                        TabsView().environmentObject(userVM)
//                    }
//                } label: {
//                    EmptyView()
//                }
            }
            .padding()
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMSG), dismissButton: .default(Text("Aceptar")))
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserViewModel())
    }
}
