//
//  Cartitem.swift
//  Week4.team
//
//  Created by MAY 05 on 5/10/26.
//
import Foundation

struct CartItem: Identifiable, Hashable, Codable {

    // MARK: - Thuộc tính lưu trữ

    /// Mã định danh của dòng giỏ hàng.
    let id: UUID

    /// Sản phẩm được chọn mua.
    var product: Product

    /// Số lượng mua (luôn >= 1).
    var quantity: Int

    // MARK: - Khởi tạo

    init(id: UUID = UUID(), product: Product, quantity: Int = 1) {
        self.id = id
        self.product = product
        self.quantity = max(1, quantity)
    }

    // MARK: - Thuộc tính tính toán

    /// Thành tiền của dòng này = đơn giá × số lượng.
    var subtotal: Double {
        product.price * Double(quantity)
    }

    /// Thành tiền đã định dạng, ví dụ: "60.000đ".
    var formattedSubtotal: String { subtotal.vndFormatted }

    /// Số tiền tiết kiệm được nhờ khuyến mãi.
    var savedAmount: Double {
        guard let originalPrice = product.originalPrice, originalPrice > product.price else { return 0 }
        return (originalPrice - product.price) * Double(quantity)
    }

    /// Có thể tăng thêm số lượng không (không vượt quá tồn kho).
    var canIncrease: Bool { quantity < product.stock }

    /// Có thể giảm số lượng không (tối thiểu là 1).
    var canDecrease: Bool { quantity > 1 }

    // MARK: - Phương thức thay đổi (mutating vì struct là kiểu giá trị)

    /// Tăng số lượng thêm 1. Trả về `false` nếu đã đạt giới hạn tồn kho.
    @discardableResult
    mutating func increase() -> Bool {
        guard canIncrease else { return false }
        quantity += 1
        return true
    }

    /// Giảm số lượng đi 1. Trả về `false` nếu đang là 1.
    @discardableResult
    mutating func decrease() -> Bool {
        guard canDecrease else { return false }
        quantity -= 1
        return true
    }

    /// Đặt số lượng mới, tự giới hạn trong khoảng 1...tồn kho.
    mutating func setQuantity(_ newValue: Int) {
        let upperBound = max(1, product.stock)
        quantity = min(max(1, newValue), upperBound)
    }
}

// MARK: - Tiện ích cho mảng giỏ hàng

extension Array where Element == CartItem {

    /// Tổng số lượng sản phẩm (dùng cho badge giỏ hàng trên header).
    var totalQuantity: Int {
        reduce(0) { $0 + $1.quantity }
    }

    /// Tổng tiền hàng (chưa gồm phí ship).
    var totalAmount: Double {
        reduce(0) { $0 + $1.subtotal }
    }

    /// Tổng tiền tiết kiệm nhờ khuyến mãi.
    var totalSaved: Double {
        reduce(0) { $0 + $1.savedAmount }
    }

    /// Thêm sản phẩm vào giỏ:
    /// - Nếu đã có → cộng dồn số lượng (không vượt tồn kho).
    /// - Nếu chưa có → thêm dòng mới.
    /// Trả về `false` nếu sản phẩm hết hàng.
    @discardableResult
    mutating func add(_ product: Product, quantity: Int = 1) -> Bool {
        guard product.isInStock, quantity > 0 else { return false }

        if let index = firstIndex(where: { $0.product.id == product.id }) {
            self[index].setQuantity(self[index].quantity + quantity)
        } else {
            var item = CartItem(product: product)
            item.setQuantity(quantity)
            append(item)
        }
        return true
    }

    /// Xóa toàn bộ dòng chứa sản phẩm khỏi giỏ.
    mutating func remove(_ product: Product) {
        removeAll { $0.product.id == product.id }
    }
}

// MARK: - Dữ liệu mẫu

extension CartItem {

    /// Giỏ hàng mẫu gồm 2 dòng sản phẩm (dùng `sampleCart.count` cho badge "2" trên header).
    static let sampleCart: [CartItem] = [
        CartItem(product: Product.sampleProducts[0], quantity: 10), // Cá Neon Tetra
        CartItem(product: Product.sampleProducts[3], quantity: 2)   // Cây Java Fern
    ]
}
