//
//  SearchBarView.swift
//  Week4.team
//
//  Created by MAY 02 on 5/10/26.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String 
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Tìm cá, cây thủy sinh, phụ kiện...", text: $searchText)
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.gray)
            }
            .padding(10)
            .background(Color(.systemGray))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}
