//
//  LocationRowView.swift
//  Week4.team
//
//  Created by MAY 02 on 5/10/26.
//

import SwiftUI

struct LocationRowView: View {
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(.blue)
            
            Text("Giao đến:")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Phường Trảng Dài, TP. Biên Hòa")
                .font(.subheadline)
                .bold()
                .lineLimit(1)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}
