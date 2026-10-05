//
//  OrderStatus.swift
//  Week4.team
//
//  Created by MAY 05 on 5/10/26.
import Foundation

enum OrderStatus: String, CaseIterable, Codable, Identifiable {

    // MARK: - Các trạng thái

    case pending   = "Chờ xử lý"
    case preparing = "Đang chuẩn bị"
    case shipping  = "Đang giao"
    case delivered = "Đã giao"
    case cancelled = "Đã hủy"

    // MARK: - Identifiable

    var id: String { rawValue }

    // MARK: - Hiển thị

    var displayName: String { rawValue }

    var iconName: String {
        switch self {
        case .pending:   return "clock"
        case .preparing: return "shippingbox"
        case .shipping:  return "truck.box"
        case .delivered: return "checkmark.seal.fill"
        case .cancelled: return "xmark.circle.fill"
        }
    }

    var colorName: String {
        switch self {
        case .pending:   return "orange"
        case .preparing: return "blue"
        case .shipping:  return "purple"
        case .delivered: return "green"
        case .cancelled: return "red"
        }
    }

    var message: String {
        switch self {
        case .pending:   return "Cửa hàng đã nhận đơn và sẽ xác nhận sớm."
        case .preparing: return "Cá và sản phẩm đang được đóng gói an toàn."
        case .shipping:  return "Đơn hàng đang trên đường giao đến bạn."
        case .delivered: return "Giao hàng thành công. Cảm ơn bạn đã mua sắm!"
        case .cancelled: return "Đơn hàng đã bị hủy."
        }
    }

    // MARK: - Logic chuyển trạng thái

    var step: Int {
        switch self {
        case .pending:   return 0
        case .preparing: return 1
        case .shipping:  return 2
        case .delivered: return 3
        case .cancelled: return -1
        }
    }
    var next: OrderStatus? {
        switch self {
        case .pending:   return .preparing
        case .preparing: return .shipping
        case .shipping:  return .delivered
        case .delivered, .cancelled: return nil
        }
    }

    var isFinished: Bool {
        self == .delivered || self == .cancelled
    }

    var canCancel: Bool {
        self == .pending || self == .preparing
    }

    static var progressSteps: [OrderStatus] {
        [.pending, .preparing, .shipping, .delivered]
    }
}

