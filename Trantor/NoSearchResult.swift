//
//  NoSearchResult.swift
//  Trantor
//
//  Created by Enrique on 25/2/23.
//

import SwiftUI

struct NoSearchResult: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.primary)
            Text("Sin resultados")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.red)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay (Spacer())
    }
}


struct NoSearchResult_Previews: PreviewProvider {
    static var previews: some View {
        NoSearchResult()
    }
}
