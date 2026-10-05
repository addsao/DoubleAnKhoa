//
//  ContentView.swift
//  Week4.team
//
//  Created by MAY 02 on 5/10/26.
//

import SwiftUI

struct ContentView: View {
    // 1. Khai báo ViewModel
    @EnvironmentObject var controller: StoreController

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    HomeHeaderView(
                        storeName: "thegioicacanh.com",
                        subtitle: "Cá khong an muoi ca uon ♡"
                    )
                    
                    LocationRowView()
                    
                    SearchBarView(searchText: $controller.searchText)
                    
                    BannerView()
                        .padding(.vertical, 4)
                    
                    CategoryRowView(
                        categories: controller.categories,
                        selectedCategory: $controller.selectedCategory
                    )
                    .padding(.vertical, 4)
                    
                    ProductSectionView(
                        title: controller.selectedCategory?.name ?? "Sản phẩm nổi bật",
                        products: controller.filteredProducts
                    )
                }
                .padding(.bottom, 20)
            }
            .background(backgroundColor)
            #if os(iOS)
            .toolbar(.hidden, for: .navigationBar)
            #endif
        }
    }
    
    private var backgroundColor: Color {
        #if os(iOS)
        return Color(uiColor: .systemGroupedBackground)
        #else
        return Color.gray.opacity(0.1)
        #endif
    }
}

#Preview {
    ContentView()
        .environmentObject(StoreController())
}
