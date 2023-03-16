//
//  ReadedButton.swift
//  Trantor
//
//  Created by Enrique on 9/3/23.
//

import SwiftUI

struct ReadedIcon: View {
    let readed:Bool
    
    var body: some View {
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
                        .frame(width: 25)
                        .foregroundColor(.primary)
                        .padding()
                }
            }
    }

struct ReadedIcon_Previews: PreviewProvider {
    static var previews: some View {
        ReadedIcon(readed: true)
    }
}
