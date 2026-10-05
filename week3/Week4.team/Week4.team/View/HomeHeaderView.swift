//
//  HomeHeaderView.swift
//  Week4.team
//
//  Created by MAY 02 on 5/10/26.
//

import SwiftUI

struct HomeHeaderView: View {
    var storeName: String
    var subtitle: String
    @EnvironmentObject var controller: StoreController

    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(storeName)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button { } label: {
                ZStack {
                    Image(systemName: "bell")
                        .font(.title3)
                    Circle()
                        .fill(Color.red)
                        .frame(width: 18, height: 18)
                        .overlay(Text("3").font(.caption2).foregroundColor(.white))
                        .offset(x: 8, y: -8)
                }
            }
            .padding(.trailing, 8)
            
            NavigationLink(destination: CartView()) {
                ZStack {
                    Image(systemName: "cart")
                        .font(.title3)
                        .foregroundColor(.primary)
                    if controller.cartBadgeCount > 0 {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 18, height: 18)
                            .overlay(
                                Text("\(controller.cartBadgeCount)")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                            )
                            .offset(x: 8, y: -8)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

#Preview {
    HomeHeaderView(storeName: "Cá Cảnh Xinh", subtitle: "Thế giới thủy sinh")
        .environmentObject(StoreController())
}
