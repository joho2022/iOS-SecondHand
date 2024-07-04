//
//  CategoryGridView.swift
//  secondhand
//
//  Created by 조호근 on 6/18/24.
//

import SwiftUI

struct CategoryGridView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCategory: Category?
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            Spacer().frame(height: 16)
            
            LazyVGrid(columns: columns, spacing: 16) {
                CategoryItemView(
                    imageName: "icon_all",
                    title: "전체상품") {
                        selectedCategory = nil
                        dismiss()
                    }
                
                ForEach(Category.allCases, id: \.self) { category in
                    CategoryItemView(
                        imageName: category.imageName,
                        title: category.rawValue
                    ) {
                        selectedCategory = category
                        dismiss()
                    }
                } // ForEach
            } // LazyVGrid
            .padding([.horizontal, .bottom], 20)
            
            Spacer().frame(height: 16)
        } // VStack
        .navigationBarTitle("카테고리", displayMode: .inline)
        .padding(.top, 16)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var value: Category?
        
        var body: some View {
            CategoryGridView(selectedCategory: $value)
        }
    }
    return PreviewWrapper()
}
