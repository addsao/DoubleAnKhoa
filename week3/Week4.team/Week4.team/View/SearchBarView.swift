//
//  SearchBarView.swift
//  Week4.team
//
//  Created by MAY 02 on 5/10/26.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(isFocused ? .blue : .gray)
                
                TextField("Tìm cá, cây thủy sinh, phụ kiện...", text: $searchText)
                    .focused($isFocused)
                    .autocorrectionDisabled()
                    .onSubmit {
                        isFocused = false
                    }
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(10)
            .background(Color(.systemGray))
            .cornerRadius(12)
            .onTapGesture {
                isFocused = true
            }
            
            if isFocused || !searchText.isEmpty {
                Button("Hủy") {
                    searchText = ""
                    isFocused = false
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
    }
}
