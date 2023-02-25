//
//  RatingStars.swift
//  Trantor
//
//  Created by Enrique Suárez on 24/2/23.
//

import SwiftUI

struct RatingStars: View {
    let rating: Double

    var body: some View {
        HStack(spacing: 5) {
            ForEach(1..<6) { index in
                if rating >= Double(index) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                } else if rating >= Double(index) - 0.5 {
                    Image(systemName: "star.leadinghalf.fill")
                        .foregroundColor(.yellow)
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
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
