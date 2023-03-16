//
//  OrderButton.swift
//  Trantor
//
//  Created by Enrique on 14/3/23.
//

import SwiftUI

struct OrderButton: View {
    @EnvironmentObject var cartVM:CartViewModel
    @EnvironmentObject var userVM:UserViewModel
    @State private var showConfirm          = false
    @State private var showOrderConfirmView = false
    @State private var isLoading            = false
    
    var body: some View {
        ZStack {
            Button (action: {
                self.showConfirm = true
            })  {
                Image(systemName: "creditcard.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45)
                    .foregroundColor(.blue)
                //.padding()
                Text("COMPRAR")
            }
            .buttonStyle(BuyButtonStyle())
            .alert(isPresented: $showConfirm) {
                Alert(
                    title: Text("CONFIRME LA COMPRA"),
                    message: Text("Se procesará el pago y se realizará el envío. Recibirá un email con el resumen del pedio."),
                    primaryButton: .default(Text("Aceptar")) {
                        Task {
                            isLoading = true
                            await cartVM.placeOrder(email: userVM.usuario.email, booksID: cartVM.booksIDToShop)
                            isLoading = false
                            self.showOrderConfirmView = true
                        }
                    },
                    secondaryButton: .cancel(Text("Cancelar"))
                )
            }
            .sheet(isPresented: $showOrderConfirmView, onDismiss: {
                cartVM.reset()
            }) {
                OrderConfirmView(order: cartVM.orderPlacedDetails)
            }
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(3, anchor: .center)
                    .opacity(1)
                    .frame(width: 60, height: 60)
                    //.foregroundColor(.yellow)
                    //.background(Color.primary.opacity(1))
                    //.cornerRadius(10)
                    .padding(.bottom)
            }
        }
    }
}


struct OrderButton_Previews: PreviewProvider {
    static var previews: some View {
        OrderButton()
            .environmentObject(UserViewModel())
            .environmentObject(CartViewModel())
    }
}
