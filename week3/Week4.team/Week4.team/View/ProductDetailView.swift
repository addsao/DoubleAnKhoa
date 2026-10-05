import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var controller: StoreController
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedQuantity: Int = 1
    @State private var isFavorite: Bool = false
    @State private var showAddedToast: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                // 1. Hình ảnh sản phẩm
                ZStack(alignment: .topLeading) {
                    Image(product.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 280)
                        .clipped()
                        .background(Color.gray.opacity(0.1))
                    
                    if product.isOnSale {
                        Text("-\(product.discountPercent)%")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .cornerRadius(8)
                            .padding(16)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        Text(product.name)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button {
                            isFavorite.toggle()
                        } label: {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.title3)
                                .foregroundColor(isFavorite ? .red : .gray)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                                .font(.subheadline)
                            Text(String(format: "%.1f", product.rating))
                                .font(.subheadline)
                                .bold()
                        }
                        
                        Text("•")
                            .foregroundColor(.gray)
                        
                        Text(product.stockText)
                            .font(.subheadline)
                            .foregroundColor(product.isInStock ? .green : .red)
                            .bold()
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(product.formattedPrice)
                            .font(.title)
                            .bold()
                            .foregroundColor(.blue)
                        
                        if let original = product.formattedOriginalPrice {
                            Text(original)
                                .font(.subheadline)
                                .strikethrough()
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 4)
                    
                    Text("Mô tả sản phẩm")
                        .font(.headline)
                    
                    Text(product.description.isEmpty ? "Chưa có mô tả chi tiết cho sản phẩm này." : product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                    
                    Divider()
                        .padding(.vertical, 4)
                    
                    if product.isInStock {
                        HStack {
                            Text("Số lượng mua:")
                                .font(.subheadline)
                                .bold()
                            
                            Spacer()
                            
                            HStack(spacing: 12) {
                                Button {
                                    if selectedQuantity > 1 { selectedQuantity -= 1 }
                                } label: {
                                    Image(systemName: "minus")
                                        .frame(width: 32, height: 32)
                                        .background(Color.gray.opacity(0.15))
                                        .cornerRadius(8)
                                }
                                .disabled(selectedQuantity <= 1)
                                
                                Text("\(selectedQuantity)")
                                    .font(.headline)
                                    .frame(minWidth: 24)
                                
                                Button {
                                    if selectedQuantity < product.stock { selectedQuantity += 1 }
                                } label: {
                                    Image(systemName: "plus")
                                        .frame(width: 32, height: 32)
                                        .background(Color.gray.opacity(0.15))
                                        .cornerRadius(8)
                                }
                                .disabled(selectedQuantity >= product.stock)
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 100)
        }
        .overlay(alignment: .bottom) {
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 12) {
                    Button {
                        controller.addToCart(product: product, quantity: selectedQuantity)
                        withAnimation {
                            showAddedToast = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation { showAddedToast = false }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "cart.badge.plus")
                            Text("Thêm vào giỏ")
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue.opacity(0.12))
                        .cornerRadius(12)
                    }
                    .disabled(!product.isInStock)
                    
                    Button {
                        controller.addToCart(product: product, quantity: selectedQuantity)
                        dismiss()
                    } label: {
                        Text("Mua ngay")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(product.isInStock ? Color.blue : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!product.isInStock)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
        }
        .overlay(alignment: .top) {
            if showAddedToast {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Đã thêm \(selectedQuantity) x \(product.name) vào giỏ!")
                        .font(.subheadline)
                        .bold()
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(25)
                .padding(.top, 20)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .navigationTitle(product.name)
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: Product.preview)
            .environmentObject(StoreController())
    }
}
