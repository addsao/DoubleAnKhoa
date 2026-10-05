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
        NavigationLink(destination: ProductDetailView(product: product)) {
            VStack(alignment: .leading, spacing: 6) {
                ZStack(alignment: .topTrailing) {
                    Image(product.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                        .clipped()
                    
                    Button { } label: {
                        Image(systemName: "heart")
                            .padding(6)
                            .background(Color.white)
                            .clipShape(Circle())
                            .padding(4)
                    }
                }
                
                Text(product.name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .padding(.horizontal, 6)
                
                Text(product.formattedPrice)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.red)
                    .padding(.horizontal, 6)
                    .padding(.bottom, 6)
            }
            .frame(width: 130)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}
