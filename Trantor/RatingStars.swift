//
//  RatingStars.swift
//  Trantor
//
//  Created by Enrique Suárez on 24/2/23.
//

import SwiftUI

struct RatingStars: View {
    let rating: Double
    let size: CGFloat = 14

    var body: some View {
        HStack(spacing: 0) {
            ForEach(1..<6) { index in
                if rating >= Double(index) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: size))
                } else if rating >= Double(index) - 0.5 {
                    Image(systemName: "star.leadinghalf.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: size))
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                        .font(.system(size: size))
                }
            }
        }
    }
}
    
struct RatingStars_Previews: PreviewProvider {
    static var previews: some View {
        RatingStars(rating: 2.5)
    }
}
