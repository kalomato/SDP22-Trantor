//
//  LoginView.swift
//  Trantor
//
//  Created by Enrique Suárez on 27/2/23.
//
// Nueva rama

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userVM:UserViewModel
    @EnvironmentObject var connectionStatus:ConnectionStatus
    
    @State private var email         = ""
    @State private var password      = ""
    @State private var validEmail    = false
    @State private var validPassword = false
    @State var showError             = false
    @State var errorMSG              = ""
    
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
                    .foregroundColor(.primary)
                Text("Nota: La contraseña no se valida")
                    .font(.footnote)
                    .italic()
                    .foregroundColor(.gray)
                
                VStack(spacing: 16) {
                    TextField("Correo electrónico", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                .onAppear {
                    email = "enrique@tizona.net"
                    password = "123456"
                }
                
                Button(action: {
                    validEmail = userVM.validaEmail(email)
                    validPassword = userVM.validaPassword(password)
                    if validEmail && validPassword {
                        Task {
                            userVM.logged = await userVM.login(email: email, pass: password)
                            if !userVM.logged {
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
                //No consigo cambiar esta llamada de forma que no me avise de que está "deprecado"
                NavigationLink(destination: TabsView().environmentObject(userVM), isActive: $userVM.logged, label: { EmptyView() })
            }
            .padding()
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMSG), dismissButton: .default(Text("Aceptar")))
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .modifier(NoConnectionAlert())
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserViewModel())
            .environmentObject(ConnectionStatus())
    }
}
