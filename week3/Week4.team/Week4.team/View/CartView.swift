//
//  CartView.swift
//  Week4.team
//
//  Created by MAY 02 on 5/10/26.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var controller: StoreController
    @State private var showCheckoutSheet: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                if controller.cart.isEmpty {
                    emptyCartView
                } else {
                    List {
                        Section(header: Text("Sản phẩm đã chọn (\(controller.cart.totalQuantity))")) {
                            ForEach(controller.cart) { item in
                                CartItemRowView(item: item)
                            }
                            .onDelete(perform: removeItem)
                        }
                        
                        Section(header: Text("Tóm tắt chi phí")) {
                            HStack {
                                Text("Tiền hàng")
                                Spacer()
                                Text(controller.cart.totalAmount.vndFormatted)
                            }
                            
                            if controller.cart.totalSaved > 0 {
                                HStack {
                                    Text("Tiết kiệm được")
                                    Spacer()
                                    Text("-\(controller.cart.totalSaved.vndFormatted)")
                                        .foregroundColor(.green)
                                }
                            }
                            
                            HStack {
                                Text("Phí giao hàng")
                                Spacer()
                                let fee = Order.calculateShippingFee(for: controller.cart.totalAmount)
                                Text(fee == 0 ? "Miễn phí" : fee.vndFormatted)
                                    .foregroundColor(fee == 0 ? .green : .primary)
                            }
                        }
                    }                    
                    checkoutBottomBar
                }
            }
            .navigationTitle("Giỏ hàng")
            .sheet(isPresented: $showCheckoutSheet) {
                CheckoutView()
                    .environmentObject(controller)
            }
        }
    }

    
    private var emptyCartView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "cart.fill.badge.minus")
                .font(.system(size: 64))
                .foregroundColor(.gray.opacity(0.6))
            
            Text("Giỏ hàng của bạn đang trống")
                .font(.headline)
            
            Text("Hãy chọn cho mình những chú cá cảnh hoặc phụ kiện ưng ý nhé!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }

    private var checkoutBottomBar: some View {
        VStack(spacing: 12) {
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tổng cộng")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(controller.cart.totalAmount.vndFormatted)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button {
                    showCheckoutSheet = true
                } label: {
                    Text("Tiến hành đặt hàng")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(backgroundColor)
    }

    private func removeItem(at offsets: IndexSet) {
        controller.cart.remove(atOffsets: offsets)
    }

    private var backgroundColor: Color {
        #if os(iOS)
        return Color(uiColor: .systemBackground)
        #else
        return Color.white
        #endif
    }
}


struct CartItemRowView: View {
    let item: CartItem
    @EnvironmentObject var controller: StoreController

    var body: some View {
        HStack(spacing: 12) {
            Image(item.product.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                
                Text(item.product.formattedPrice)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                
                Text("Thành tiền: \(item.formattedSubtotal)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button {
                    if let index = controller.cart.firstIndex(where: { $0.id == item.id }) {
                        _ = controller.cart[index].decrease()
                    }
                } label: {
                    Image(systemName: "minus.circle")
                        .font(.title3)
                        .foregroundColor(item.canDecrease ? .blue : .gray)
                }
                .disabled(!item.canDecrease)
                .buttonStyle(.plain)
                
                Text("\(item.quantity)")
                    .font(.subheadline)
                    .bold()
                    .frame(minWidth: 20)
                
                Button {
                    if let index = controller.cart.firstIndex(where: { $0.id == item.id }) {
                        _ = controller.cart[index].increase()
                    }
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                        .foregroundColor(item.canIncrease ? .blue : .gray)
                }
                .disabled(!item.canIncrease)
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
    }
}
