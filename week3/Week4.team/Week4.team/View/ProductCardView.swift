//
//  ProductCardView.swift
//  Week4.team
//
//  Created by MAY 01 on 5/10/26.
//


import SwiftUI

struct ProductCardView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Image(product.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .clipped()
                Image(systemName: "heart")
                    .padding(8)
                    .background(.white)
                    .clipShape(Circle())
            }
            Text(product.name)
                .font(.subheadline)
                .lineLimit(1)
            Text("\(product.price, specifier: \"%.0f\")đ")
                .font(.subheadline)
                .foregroundColor(.red)
        }
        .frame(width: 110)
        .background(.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}