//
//  Order.swift
//  Week4.team
//
//  Created by MAY 05 on 5/10/26.
//

import Foundation
import Foundation

struct Order: Identifiable, Hashable, Codable {

 
    let id: UUID
    var customerName: String
    var phoneNumber: String
    var shippingAddress: String
    var items: [CartItem]
    var orderDate: Date
    var status: OrderStatus
    var shippingFee: Double
    var note: String

    static let defaultShippingFee: Double = 30_000
    static let freeShippingThreshold: Double = 500_000


    init(
        id: UUID = UUID(),
        customerName: String,
        phoneNumber: String = "",
        shippingAddress: String = "",
        items: [CartItem],
        orderDate: Date = Date(),
        status: OrderStatus = .pending,
        shippingFee: Double? = nil,
        note: String = ""
    ) {
        self.id = id
        self.customerName = customerName
        self.phoneNumber = phoneNumber
        self.shippingAddress = shippingAddress
        self.items = items
        self.orderDate = orderDate
        self.status = status
        self.note = note
        self.shippingFee = shippingFee ?? Order.calculateShippingFee(for: items.totalAmount)
    }

    init(from cart: [CartItem], customerName: String, phoneNumber: String, shippingAddress: String, note: String = "") {
        self.init(
            customerName: customerName,
            phoneNumber: phoneNumber,
            shippingAddress: shippingAddress,
            items: cart,
            note: note
        )
    }


    static func calculateShippingFee(for subtotal: Double) -> Double {
        subtotal >= freeShippingThreshold ? 0 : defaultShippingFee
    }

    var subtotal: Double { items.totalAmount }
    var totalAmount: Double { subtotal + shippingFee }
    var totalQuantity: Int { items.totalQuantity }
    var isFreeShipping: Bool { shippingFee == 0 }
    var formattedSubtotal: String { subtotal.vndFormatted }
    var formattedShippingFee: String {isFreeShipping ? "Miễn phí" : shippingFee.vndFormatted}

    var formattedTotal: String { totalAmount.vndFormatted }


    var orderCode: String {
        "DH-" + id.uuidString.prefix(6).uppercased()
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter
    }()

    var formattedDate: String {
        Order.dateFormatter.string(from: orderDate)
    }

    var itemsSummary: String {
        guard let first = items.first else { return "Không có sản phẩm" }
        let others = items.count - 1
        return others > 0
            ? "\(first.product.name) và \(others) sản phẩm khác"
            : first.product.name
    }


    var isValid: Bool {
        !customerName.trimmingCharacters(in: .whitespaces).isEmpty
            && !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty
            && !shippingAddress.trimmingCharacters(in: .whitespaces).isEmpty
            && !items.isEmpty
    }


    @discardableResult
    mutating func advanceStatus() -> Bool {
        guard let next = status.next else { return false }
        status = next
        return true
    }

    @discardableResult
    mutating func cancel() -> Bool {
        guard status.canCancel else { return false }
        status = .cancelled
        return true
    }
}


extension Array where Element == Order {

    func filtered(by status: OrderStatus?) -> [Order] {
        guard let status else { return self }
        return filter { $0.status == status }
    }

    var sortedByNewest: [Order] {
        sorted { $0.orderDate > $1.orderDate }
    }

    var totalRevenue: Double {
        filter { $0.status == .delivered }.reduce(0) { $0 + $1.totalAmount }
    }
}


extension Order {

    private static let products = Product.sampleProducts

    static let sampleOrders: [Order] = [
        Order(
            customerName: "Nguyễn Văn An",
            phoneNumber: "0901234567",
            shippingAddress: "Phường Trấn Biên, Thành phố Đồng Nai",
            items: [
                CartItem(product: products[0], quantity: 10), // Cá Neon Tetra
                CartItem(product: products[3], quantity: 2)   // Cây Java Fern
            ],
            orderDate: Date().addingTimeInterval(-2 * 3600),  // 2 giờ trước
            status: .pending,
            note: "Gọi trước khi giao"
        ),
        Order(
            customerName: "Trần Thị Bình",
            phoneNumber: "0912345678",
            shippingAddress: "Phường Bến Thành, TP. Hồ Chí Minh",
            items: [
                CartItem(product: products[6], quantity: 1),  // Bể kính 60cm
                CartItem(product: products[7], quantity: 1)   // Máy lọc nước
            ],
            orderDate: Date().addingTimeInterval(-26 * 3600), // hôm qua
            status: .shipping
        ),
        Order(
            customerName: "Lê Minh Châu",
            phoneNumber: "0987654321",
            shippingAddress: "Phường Thủ Dầu Một, TP. Hồ Chí Minh",
            items: [
                CartItem(product: products[11], quantity: 20), // Tép Red Cherry
                CartItem(product: products[9], quantity: 1)    // Thức ăn Tetra Bits
            ],
            orderDate: Date().addingTimeInterval(-3 * 24 * 3600), // 3 ngày trước
            status: .delivered
        ),
        Order(
            customerName: "Phạm Quốc Dũng",
            phoneNumber: "0933111222",
            shippingAddress: "Phường Trấn Biên, Thành phố Đồng Nai",
            items: [
                CartItem(product: products[1], quantity: 2)    // Cá Vàng Ranchu
            ],
            orderDate: Date().addingTimeInterval(-5 * 24 * 3600),
            status: .cancelled,
            note: "Khách đổi ý"
        )
    ]

    static let preview = sampleOrders[0]
}
