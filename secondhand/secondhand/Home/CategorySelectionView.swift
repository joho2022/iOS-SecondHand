//
//  CategorySelectionView.swift
//  secondhand
//
//  Created by 조호근 on 6/18/24.
//

import SwiftUI

struct CategorySelectionView: View {
    @Environment(\.presentationMode) var presentationMode
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
                VStack {
                    Image("icon_all")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 44)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.customOrange, lineWidth: 2)
                        )
                    Text("전체상품")
                        .font(.system(size: 13, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.customGray900)
                }
                .onTapGesture {
                    selectedCategory = nil
                    presentationMode.wrappedValue.dismiss()
                }
                
                ForEach(Category.allCases, id: \.self) { category in
                    VStack {
                        Image(category.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 44)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.customOrange, lineWidth: 2)
                            )
                        Text(category.rawValue)
                            .font(.system(size: 13, weight: .regular))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.customGray900)
                    }
                    .onTapGesture {
                        selectedCategory = category
                        presentationMode.wrappedValue.dismiss()
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
            CategorySelectionView(selectedCategory: $value)
        }
    }
    return PreviewWrapper()
}
