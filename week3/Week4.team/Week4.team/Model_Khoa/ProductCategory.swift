//
//  ProductCategory.swift
//  Week4.team
//
//  Created by MAY 05 on 5/10/26.
//
import Foundation

struct ProductCategory: Identifiable, Hashable, Codable {
    
    let id: UUID
    var name: String
    var iconName: String
    var systemIconName: String
    var subtitles: [String]
    var backgroundHex: String
    var isProductCategory: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        iconName: String,
        systemIconName: String = "square.grid.2x2",
        subtitles: [String] = [],
        backgroundHex: String = "#EAF4FF",
        isProductCategory: Bool = true
    ) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.systemIconName = systemIconName
        self.subtitles = subtitles
        self.backgroundHex = backgroundHex
        self.isProductCategory = isProductCategory
    }
    
    var subtitleText: String {
        subtitles.joined(separator: "\n")
    }
}

extension ProductCategory {
    
    static let fish = ProductCategory(
        name: "Cá cảnh",
        iconName: "cat_fish",
        systemIconName: "fish.fill",
        subtitles: ["Cá nước ngọt", "Cá biển"],
        backgroundHex: "#FFEDE6"
    )
    
    static let plant = ProductCategory(
        name: "Cây thủy sinh",
        iconName: "cat_plant",
        systemIconName: "leaf.fill",
        subtitles: ["Cây tiền cảnh", "Cây trung cảnh"],
        backgroundHex: "#E8F7E4"
    )
    
    static let decoration = ProductCategory(
        name: "Phụ kiện bể",
        iconName: "cat_decoration",
        systemIconName: "mountain.2.fill",
        subtitles: ["Đá, lũa, nền"],
        backgroundHex: "#EEF1F5"
    )
    
    static let tank = ProductCategory(
        name: "Bể cá",
        iconName: "cat_tank",
        systemIconName: "cube.transparent",
        subtitles: ["Bể thủy sinh", "Bể kính"],
        backgroundHex: "#E4F3FC"
    )
    
    static let filter = ProductCategory(
        name: "Thiết bị lọc",
        iconName: "cat_filter",
        systemIconName: "fan.fill",
        subtitles: ["Máy lọc, sủi khí", "Đèn LED"],
        backgroundHex: "#E9EEF6"
    )
    
    static let food = ProductCategory(
        name: "Thức ăn",
        iconName: "cat_food",
        systemIconName: "takeoutbag.and.cup.and.straw.fill",
        subtitles: ["Thức ăn cá", "Thức ăn tép"],
        backgroundHex: "#FFF1E3"
    )
    
    static let medicine = ProductCategory(
        name: "Thuốc & Chăm sóc",
        iconName: "cat_medicine",
        systemIconName: "cross.case.fill",
        subtitles: ["Thuốc trị bệnh", "Dinh dưỡng"],
        backgroundHex: "#E6EEFF"
    )
    
    static let shrimp = ProductCategory(
        name: "Tép cảnh",
        iconName: "cat_shrimp",
        systemIconName: "drop.fill",
        subtitles: ["Tép kiểng", "Tép màu"],
        backgroundHex: "#FFEDE6"
    )
    
    static let promotion = ProductCategory(
        name: "Khuyến mãi",
        iconName: "cat_promotion",
        systemIconName: "tag.fill",
        subtitles: ["Ưu đãi hôm nay"],
        backgroundHex: "#FFEDE3",
        isProductCategory: false
    )
    
    static let support = ProductCategory(
        name: "Tư vấn",
        iconName: "cat_support",
        systemIconName: "bubble.left.and.bubble.right.fill",
        subtitles: ["Hỏi đáp", "Kinh nghiệm"],
        backgroundHex: "#E6F7EA",
        isProductCategory: false
    )
    
    static let sampleCategories: [ProductCategory] = [
        fish,
        plant,
        decoration,
        tank,
        filter,
        food,
        medicine,
        shrimp,
        promotion,
        support
    ]
    
    static func find(
        by id: UUID,
        in categories: [ProductCategory] = sampleCategories
    ) -> ProductCategory? {
        categories.first { $0.id == id }
    }
}
