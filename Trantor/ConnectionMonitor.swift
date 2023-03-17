//
//  ConnectionMonitor.swift
//  Trantor
//
//  Created by Enrique on 12/3/23.
//

import Network
import SwiftUI

class ConnectionStatus: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ConnectionMonitor")
    
    @Published var isConnected: Bool = true

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}


struct NoConnectionAlert: ViewModifier {
    @EnvironmentObject var connectionStatus: ConnectionStatus

    func body(content: Content) -> some View {
        content
            .overlay(Group {
                if !connectionStatus.isConnected {
                    Text("NO HAY CONEXIÓN")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
            }, alignment: .top)
    }
}
