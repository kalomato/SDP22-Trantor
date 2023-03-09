//
//  ReadedButton.swift
//  Trantor
//
//  Created by Enrique on 9/3/23.
//

import SwiftUI

struct ReadedButton: View {
    let readed:Bool
    
    var body: some View {
            Button(action: {
                // llamar a la función toggleReaded
            }) {
                if readed {
                    Image(systemName: "bookmark.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                        .foregroundColor(.green)
                        .padding()
                } else {
                    Image(systemName: "bookmark.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .foregroundColor(.primary)
                        .padding()
                }
            }
            .background(Color.clear)
    }
}

struct ReadedButton_Previews: PreviewProvider {
    static var previews: some View {
        ReadedButton(readed: true)
    }
}
