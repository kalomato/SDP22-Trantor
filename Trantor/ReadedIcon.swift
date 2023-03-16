//
//  ReadedButton.swift
//  Trantor
//
//  Created by Enrique on 9/3/23.
//

import SwiftUI

struct ReadedIcon: View {
    let readed:Bool
    @State private var scale:CGFloat = 1
    
    var body: some View {
        Group {
            if readed {
                Image(systemName: "bookmark.fill")
                    .resizable()
                    .foregroundColor(.green)
            } else {
                Image(systemName: "bookmark.slash")
                    .resizable()
                    .foregroundColor(.primary)
            }
        }
        .scaledToFit()
        .frame(width: 25)
        .padding()
        .scaleEffect(scale)
        .onChange(of: readed) { _ in
            scale = 0.7
            withAnimation(.spring(response: 0.5, dampingFraction: 0.4, blendDuration: 0)) {
                scale = 1
            }
        }
    }
}


struct ReadedIcon_Previews: PreviewProvider {
    static var previews: some View {
        ReadedIcon(readed: true)
    }
}
