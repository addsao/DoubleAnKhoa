import SwiftUI

struct ProductSectionView: View {
    var title: String
    var products: [Product]
    
    @State private var isShowingAllProducts = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                    .bold()
                Spacer()
                
                Button("Xem tất cả >") {
                    isShowingAllProducts = true
                }
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
        .sheet(isPresented: $isShowingAllProducts) {
            ProductListView(title: title, products: products)
        }
    }
}
