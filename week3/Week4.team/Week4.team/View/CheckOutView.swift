//
//  CheckOutView.swift
//  Week4.team
//
//  Created by MAY 02 on 5/10/26.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var controller: StoreController
    @Environment(\.dismiss) private var dismiss

    @State private var customerName: String = "Nguyễn Văn An"
    @State private var phoneNumber: String = "0901234567"
    @State private var shippingAddress: String = "Phường Trấn Biên, Thành phố Đồng Nai"
    @State private var note: String = "Giao giờ hành chính"
    
    @State private var showAlertSuccess: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Thông tin người nhận")) {
                    TextField("Họ và tên", text: $customerName)
                    TextField("Số điện thoại", text: $phoneNumber)
                    TextField("Địa chỉ giao hàng", text: $shippingAddress)
                    TextField("Ghi chú (Ví dụ: Gọi trước khi giao)", text: $note)
                }
                
                Section(header: Text("Chi tiết đơn hàng")) {
                    ForEach(controller.cart) { item in
                        HStack {
                            Text(item.product.name)
                                .lineLimit(1)
                            Spacer()
                            Text("x\(item.quantity)")
                                .foregroundColor(.gray)
                            Text(item.formattedSubtotal)
                                .bold()
                        }
                    }
                    
                    HStack {
                        Text("Phí vận chuyển")
                        Spacer()
                        let fee = Order.calculateShippingFee(for: controller.cart.totalAmount)
                        Text(fee == 0 ? "Miễn phí" : fee.vndFormatted)
                            .foregroundColor(fee == 0 ? .green : .primary)
                    }
                    
                    HStack {
                        Text("Tổng thanh toán")
                            .bold()
                        Spacer()
                        let total = controller.cart.totalAmount + Order.calculateShippingFee(for: controller.cart.totalAmount)
                        Text(total.vndFormatted)
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Xác nhận đơn hàng")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Hủy") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Đặt hàng") {
                        controller.createOrder(
                            customerName: customerName,
                            phoneNumber: phoneNumber,
                            address: shippingAddress,
                            note: note
                        )
                        showAlertSuccess = true
                    }
                    .disabled(customerName.isEmpty || phoneNumber.isEmpty || shippingAddress.isEmpty)
                }
            }
            .alert("Đặt hàng thành công! 🎉", isPresented: $showAlertSuccess) {
                Button("Đồng ý") {
                    dismiss()
                }
            } message: {
                Text("Cảm ơn bạn đã mua sắm tại Cá Cảnh Xinh. Cửa hàng sẽ liên hệ xác nhận đơn hàng sớm nhất!")
            }
        }
    }
}

#Preview {
    CartView()
        .environmentObject(StoreController())
}
