//
//  LoadingView.swift
//  Trantor
//
//  Created by Enrique Suárez on 7/3/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                .opacity(0.95)
            VStack {
                Text("Cargando datos")
                    .font(.callout)
                ProgressView()
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
