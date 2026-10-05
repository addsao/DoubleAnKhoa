//
//  ProductSectionView.swift
//  Week4.team
//
//  Created by MAY 02 on 5/10/26.
//

import SwiftUI

struct ProductSectionView: View {
    var title: String
    var products: [Product]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                    .bold()
                Spacer()
                Button("Xem tất cả >") { }
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(products) { product in
                        ProductCardView(product: product)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
