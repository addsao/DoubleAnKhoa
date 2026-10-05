//
//  Cartitem.swift
//  Week4.team
//
//  Created by MAY 05 on 5/10/26.
//
import Foundation

struct CartItem: Identifiable, Hashable, Codable {
    let id: UUID
    var product: Product
    var quantity: Int

    init(id: UUID = UUID(), product: Product, quantity: Int = 1) {
        self.id = id
        self.product = product
        self.quantity = max(1, quantity)
    }

    var subtotal: Double {
        product.price * Double(quantity)}
    var formattedSubtotal: String { subtotal.vndFormatted }
    var savedAmount: Double {
        guard let originalPrice = product.originalPrice, originalPrice > product.price else { return 0 }
        return (originalPrice - product.price) * Double(quantity)
    }
    var canIncrease: Bool { quantity < product.stock }
    var canDecrease: Bool { quantity > 1 }


    @discardableResult
    mutating func increase() -> Bool {
        guard canIncrease else { return false }
        quantity += 1
        return true
    }

    @discardableResult
    mutating func decrease() -> Bool {
        guard canDecrease else { return false }
        quantity -= 1
        return true
    }

    mutating func setQuantity(_ newValue: Int) {
        let upperBound = max(1, product.stock)
        quantity = min(max(1, newValue), upperBound)
    }
}


extension Array where Element == CartItem {

    var totalQuantity: Int {reduce(0) { $0 + $1.quantity }}
    var totalAmount: Double {reduce(0) { $0 + $1.subtotal }}
    var totalSaved: Double {reduce(0) { $0 + $1.savedAmount }}

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

    mutating func remove(_ product: Product) {
        removeAll { $0.product.id == product.id }
    }
}


extension CartItem {
    static let sampleCart: [CartItem] = [
        CartItem(product: Product.sampleProducts[0], quantity: 10), 
        CartItem(product: Product.sampleProducts[3], quantity: 2)   
    ]
}
