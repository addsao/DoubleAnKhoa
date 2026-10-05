//
//  LocationRowView.swift
//  Week4.team
//
//  Created by MAY 02 on 5/10/26.
//

import SwiftUI

struct LocationRowView: View {
    @State private var locationName: String = "TTTM Gigamall, Phạm Văn Đồng"
    @State private var showMapSheet: Bool = false

    var body: some View {
        Button {
            showMapSheet = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.red)
                    .font(.subheadline)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Giao đến:")
                        .font(.caption2)
                        .foregroundColor(.gray)

                    HStack(spacing: 4) {
                        Text(locationName)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.primary)
                            .lineLimit(1)

                        Image(systemName: "chevron.down")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(Color.gray.opacity(0.08))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showMapSheet) {
            LocationPickerView(selectedLocationName: $locationName)
        }
    }
}

#Preview {
    LocationRowView()
}
