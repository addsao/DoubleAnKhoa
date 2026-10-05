//
//  HomeView.swift
//  Week4.team
//
//  Created by MAY 02 on 5/10/26.
//

import SwiftUI

struct HomeView: View {
    @State private var categories: [ProductCategory] = []
    @State private var products: [Product] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HomeHeaderView(
                    storeName: "Cá Cảnh Xinh",
                    subtitle: "Thế giới thủy sinh trong tầm tay ♡"
                )
                
                LocationRowView()    // (có thể tách riêng view)
                SearchBarView()      // (có thể tách riêng view)
                
                BannerView()
                    .padding(.vertical, 12)
                
                CategoryRowView(categories: categories)
                    .padding(.vertical, 8)
                
                ProductSectionView(
                    title: "Sản phẩm nổi bật",
                    products: products
                )
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
            .onAppear {
                loadSampleData()
            }
        }
    }
    
    private func loadSampleData() {
        // Tạo dữ liệu mẫu cho categories và products
        // (omitted...)
    }
}

#Preview {
    HomeView()
}
