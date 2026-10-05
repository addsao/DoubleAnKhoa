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

    // MARK: - Hằng số nghiệp vụ
    static let defaultShippingFee: Double = 30_000
    static let freeShippingThreshold: Double = 500_000

    // MARK: - Khởi tạo

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
        // Nếu không truyền phí ship → tự tính theo tổng tiền hàng.
        self.shippingFee = shippingFee ?? Order.calculateShippingFee(for: items.totalAmount)
    }

    /// Tạo đơn hàng trực tiếp từ giỏ hàng.
    init(from cart: [CartItem], customerName: String, phoneNumber: String, shippingAddress: String, note: String = "") {
        self.init(
            customerName: customerName,
            phoneNumber: phoneNumber,
            shippingAddress: shippingAddress,
            items: cart,
            note: note
        )
    }

    // MARK: - Tính tiền

    /// Phí ship theo tổng tiền hàng: miễn phí nếu đạt ngưỡng.
    static func calculateShippingFee(for subtotal: Double) -> Double {
        subtotal >= freeShippingThreshold ? 0 : defaultShippingFee
    }

    /// Tổng tiền hàng (chưa gồm phí ship).
    var subtotal: Double { items.totalAmount }

    /// Tổng thanh toán = tiền hàng + phí ship.
    var totalAmount: Double { subtotal + shippingFee }

    /// Tổng số lượng sản phẩm trong đơn.
    var totalQuantity: Int { items.totalQuantity }

    /// Đơn có được miễn phí giao hàng không.
    var isFreeShipping: Bool { shippingFee == 0 }

    var formattedSubtotal: String { subtotal.vndFormatted }

    var formattedShippingFee: String {
        isFreeShipping ? "Miễn phí" : shippingFee.vndFormatted
    }

    var formattedTotal: String { totalAmount.vndFormatted }

    // MARK: - Hiển thị

    /// Mã đơn ngắn gọn để hiển thị, ví dụ: "DH-3F2A1B".
    var orderCode: String {
        "DH-" + id.uuidString.prefix(6).uppercased()
    }

    /// Formatter ngày giờ dùng chung, ví dụ: "05/10/2026 09:41".
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter
    }()

    /// Ngày đặt đã định dạng.
    var formattedDate: String {
        Order.dateFormatter.string(from: orderDate)
    }

    /// Tóm tắt nhanh nội dung đơn, ví dụ: "Cá Neon Tetra và 1 sản phẩm khác".
    var itemsSummary: String {
        guard let first = items.first else { return "Không có sản phẩm" }
        let others = items.count - 1
        return others > 0
            ? "\(first.product.name) và \(others) sản phẩm khác"
            : first.product.name
    }

    // MARK: - Kiểm tra dữ liệu

    /// Đơn hợp lệ: có tên, số điện thoại, địa chỉ và ít nhất 1 sản phẩm.
    var isValid: Bool {
        !customerName.trimmingCharacters(in: .whitespaces).isEmpty
            && !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty
            && !shippingAddress.trimmingCharacters(in: .whitespaces).isEmpty
            && !items.isEmpty
    }

    // MARK: - Thay đổi trạng thái

    /// Chuyển sang trạng thái kế tiếp. Trả về `false` nếu đơn đã kết thúc.
    @discardableResult
    mutating func advanceStatus() -> Bool {
        guard let next = status.next else { return false }
        status = next
        return true
    }

    /// Hủy đơn. Chỉ hủy được khi đang "Chờ xử lý" hoặc "Đang chuẩn bị".
    @discardableResult
    mutating func cancel() -> Bool {
        guard status.canCancel else { return false }
        status = .cancelled
        return true
    }
}

// MARK: - Tiện ích cho danh sách đơn hàng

extension Array where Element == Order {

    /// Lọc đơn theo trạng thái (`nil` = tất cả).
    func filtered(by status: OrderStatus?) -> [Order] {
        guard let status else { return self }
        return filter { $0.status == status }
    }

    /// Sắp xếp đơn mới nhất lên đầu.
    var sortedByNewest: [Order] {
        sorted { $0.orderDate > $1.orderDate }
    }

    /// Tổng doanh thu từ các đơn đã giao thành công.
    var totalRevenue: Double {
        filter { $0.status == .delivered }.reduce(0) { $0 + $1.totalAmount }
    }
}

// MARK: - Dữ liệu mẫu

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

    /// Một đơn mẫu dùng cho Xcode Preview.
    static let preview = sampleOrders[0]
}
