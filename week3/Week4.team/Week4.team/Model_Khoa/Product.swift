//
//  Product.swift
//  Week4.team
//
//  Created by MAY 05 on 5/10/26.
//
import Foundation

struct Product: Identifiable, Hashable, Codable {
    
    let id: UUID
    var name: String
    var categoryId: UUID
    var price: Double
    var originalPrice: Double?
    var imageName: String
    var description: String
    var stock: Int
    var unit: String
    var isFeatured: Bool
    var rating: Double
    
    static let availableAssetImages: [String] = [
            "fish1",
            "fish2",
            "fish3",
            "fish4",
            "fish5",
            "fish6",
            "fish7",
            "fish8",
            "fish9",
            "fish10",
            "fish11",
            "fish12",
            "fish13",
            "fish14",
            "fish15",
            "fish16",
            "fish17",
            "fish18",
            "fish19",
            "fish20",
            "fish21",
            "fish22",
            "fish23",
        ]
    
    static var randomImageName: String {
            availableAssetImages.randomElement() ?? "fish_placeholder"
        }
    
    init(
        id: UUID = UUID(),
        name: String,
        categoryId: UUID,
        price: Double,
        originalPrice: Double? = nil,
        imageName: String,
        description: String = "",
        stock: Int = 0,
        unit: String = "cái",
        isFeatured: Bool = false,
        rating: Double = 5.0
    ) {
        self.id = id
        self.name = name
        self.categoryId = categoryId
        self.price = max(0, price)
        self.originalPrice = originalPrice
        self.imageName = imageName
        self.description = description
        self.stock = max(0, stock)
        self.unit = unit
        self.isFeatured = isFeatured
        self.rating = min(max(rating, 0), 5)
    }
    
    static let lowStockThreshold = 5
    
    var isInStock: Bool {
        stock > 0
    }
    
    var isLowStock: Bool {
        isInStock && stock <= Product.lowStockThreshold
    }
    
    var stockText: String {
        if !isInStock {
            return "Hết hàng"
        }
        
        if isLowStock {
            return "Chỉ còn \(stock) \(unit)"
        }
        
        return "Còn \(stock) \(unit)"
    }
    
    var isOnSale: Bool {
        guard let originalPrice else {
            return false
        }
        
        return originalPrice > price
    }
    
    var discountPercent: Int {
        guard let originalPrice,
              originalPrice > price,
              originalPrice > 0 else {
            return 0
        }
        
        return Int(((originalPrice - price) / originalPrice * 100).rounded())
    }
    
    var formattedPrice: String {
        price.vndFormatted
    }
    
    var formattedOriginalPrice: String? {
        originalPrice?.vndFormatted
    }
    
    func canPurchase(quantity: Int) -> Bool {
        quantity > 0 && quantity <= stock
    }
    
    func matches(keyword: String) -> Bool {
        let key = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if key.isEmpty {
            return true
        }
        
        let options: String.CompareOptions = [
            .caseInsensitive,
            .diacriticInsensitive
        ]
        
        return name.range(of: key, options: options) != nil ||
               description.range(of: key, options: options) != nil
    }
}

extension Double {
    
    private static let vndFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var vndFormatted: String {
        let number = Double.vndFormatter.string(
            from: NSNumber(value: self)
        ) ?? "\(Int(self))"
        
        return number + "đ"
    }
}

extension Product {
    
    static let sampleProducts: [Product] = [
        
        Product(
            name: "Cá Neon Tetra",
            categoryId: ProductCategory.fish.id,
            price: 20_000,
            imageName: "neon_tetra",
            description: "Cá nhỏ, màu xanh đỏ ánh kim, bơi theo đàn rất đẹp. Phù hợp bể thủy sinh.",
            stock: 120,
            unit: "con",
            isFeatured: true,
            rating: 4.8
        ),
        
        Product(
            name: "Cá Vàng Ranchu",
            categoryId: ProductCategory.fish.id,
            price: 150_000,
            originalPrice: 200_000,
            imageName: "goldfish_ranchu",
            description: "Cá vàng đầu lân, dáng tròn, màu cam trắng. Dễ nuôi, hợp bể không trồng cây.",
            stock: 4,
            unit: "con",
            isFeatured: true,
            rating: 4.7
        ),
        
        Product(
            name: "Cá Betta Halfmoon",
            categoryId: ProductCategory.fish.id,
            price: 80_000,
            imageName: "betta_halfmoon",
            description: "Đuôi xòe hình bán nguyệt, nhiều màu sắc. Nên nuôi riêng từng con.",
            stock: 25,
            unit: "con",
            rating: 4.9
        ),
        
        Product(
            name: "Cây Java Fern",
            categoryId: ProductCategory.plant.id,
            price: 50_000,
            imageName: "java_fern",
            description: "Dương xỉ Java, sống khỏe, ít cần ánh sáng, buộc lên đá hoặc lũa.",
            stock: 40,
            unit: "cây",
            isFeatured: true,
            rating: 4.6
        ),
        
        Product(
            name: "Rêu Minifiss",
            categoryId: ProductCategory.plant.id,
            price: 35_000,
            imageName: "moss_minifiss",
            description: "Rêu tiền cảnh mịn, lên màu xanh đẹp, cần CO2 để phát triển tốt.",
            stock: 0,
            unit: "vỉ",
            rating: 4.4
        ),
        
        Product(
            name: "Đá Seiryu",
            categoryId: ProductCategory.decoration.id,
            price: 60_000,
            imageName: "seiryu_stone",
            description: "Đá xám vân trắng, dùng tạo bố cục Iwagumi. Giá theo kg.",
            stock: 60,
            unit: "kg",
            rating: 4.5
        ),
        
        Product(
            name: "Bể kính siêu trong 60cm",
            categoryId: ProductCategory.tank.id,
            price: 1_200_000,
            originalPrice: 1_500_000,
            imageName: "tank_60cm",
            description: "Kính siêu trong dày 8mm, kích thước 60 × 35 × 40 cm.",
            stock: 6,
            unit: "bể",
            rating: 4.8
        ),
        
        Product(
            name: "Máy lọc nước",
            categoryId: ProductCategory.filter.id,
            price: 350_000,
            imageName: "water_filter",
            description: "Lọc thùng mini cho bể 40 – 80 cm, chạy êm, tiết kiệm điện.",
            stock: 15,
            unit: "cái",
            isFeatured: true,
            rating: 4.7
        ),
        
        Product(
            name: "Đèn LED thủy sinh 60cm",
            categoryId: ProductCategory.filter.id,
            price: 420_000,
            imageName: "led_light",
            description: "Đèn full spectrum giúp cây lên màu và cá tươi màu.",
            stock: 3,
            unit: "cái",
            rating: 4.6
        ),
        
        Product(
            name: "Thức ăn cá Tetra Bits",
            categoryId: ProductCategory.food.id,
            price: 45_000,
            imageName: "food_tetra",
            description: "Thức ăn dạng hạt chìm chậm, bổ sung vitamin, giúp cá lên màu.",
            stock: 80,
            unit: "hộp",
            rating: 4.5
        ),
        
        Product(
            name: "Vi sinh làm trong nước",
            categoryId: ProductCategory.medicine.id,
            price: 65_000,
            imageName: "bio_bacteria",
            description: "Bổ sung vi sinh có lợi, giảm ammonia, giúp nước trong nhanh.",
            stock: 30,
            unit: "chai",
            rating: 4.4
        ),
        
        Product(
            name: "Tép Red Cherry",
            categoryId: ProductCategory.shrimp.id,
            price: 15_000,
            imageName: "shrimp_red_cherry",
            description: "Tép màu đỏ tươi, dọn rêu hại, sinh sản dễ trong bể cây.",
            stock: 200,
            unit: "con",
            rating: 4.7
        )
    ]
    
    static var featuredProducts: [Product] {
        sampleProducts.filter { $0.isFeatured }
    }
    
    static func products(
        in category: ProductCategory,
        from products: [Product] = sampleProducts
    ) -> [Product] {
        products.filter { $0.categoryId == category.id }
    }
    
    static let preview = sampleProducts[0]
}

extension Product {
    
    /// Khởi tạo lại danh sách dữ liệu mẫu với imageName ngẫu nhiên từ Asset Catalog
    static var sampleProductsWithRandomImages: [Product] {
        sampleProducts.map { product in
            var updated = product
            updated.imageName = Product.randomImageName
            return updated
        }
    }
}
