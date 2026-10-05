//
//  CategoryRowView.swift
//  Week4.team
//
//  Created by MAY 01 on 5/10/26.
//


import SwiftUI

struct CategoryRowView: View {
    let categories: [ProductCategory]
    @Binding var selectedCategory: ProductCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories) { cat in
                    Button {
                        if selectedCategory?.id == cat.id {
                            selectedCategory = nil
                        } else {
                            selectedCategory = cat
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: cat.systemIconName)
                                .font(.title2)
                                .frame(width: 48, height: 48)
                                .background(selectedCategory?.id == cat.id ? Color.blue.opacity(0.2) : Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .clipShape(Circle())
                            
                            Text(cat.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                        .frame(width: 72)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
