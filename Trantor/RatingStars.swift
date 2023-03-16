//
//  RatingStars.swift
//  Trantor
//
//  Created by Enrique Suárez on 24/2/23.
//

import SwiftUI

struct RatingStars: View {
    let rating: Double
    let size: CGFloat

    var body: some View {
        HStack(spacing: 0) {
            ForEach(1..<6) { value in
                if rating >= Double(value) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: size))
                } else if rating >= Double(value) - 0.5 {
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
        RatingStars(rating: 2.5, size: 16 )
    }
}
