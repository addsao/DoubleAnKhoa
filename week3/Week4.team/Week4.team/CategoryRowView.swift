import SwiftUI

struct CategoryRowView: View {
    let categories: [ProductCategory]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories) { cat in
                    VStack {
                        Image(cat.iconName)
                            .resizable()
                            .frame(width: 48, height: 48)
                        Text(cat.name)
                            .font(.subheadline)
                            .frame(width: 80)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}