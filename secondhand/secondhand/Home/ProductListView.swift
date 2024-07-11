//
//  ProductListView.swift
//  secondhand
//
//  Created by 조호근 on 6/11/24.
//

import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel: ProductListViewModel
    @Binding var selectedCategory: Category?
    @Binding var isDragging: Bool
    
    init(viewModel: ProductListViewModel, selectedCategory: Binding<Category?>, isDragging: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._selectedCategory = selectedCategory
        self._isDragging = isDragging
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.filteredProducts, id: \.id) { product in
                    ProductRow(product: product)
                }
            } // LazyVStack
            .background(GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    let newIsDragging = geo.frame(in: .global).minY < 100
                    if newIsDragging != isDragging {
                        isDragging = newIsDragging
                    }
                }
                return Color.clear
            })
        } // ScrollView
        .onChange(of: selectedCategory) { newCategory in
            viewModel.setSelectedCategory(newCategory)
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(viewModel: ProductListViewModel(userManager: UserManager(realmManager: RealmManager(realm: nil)), productManager: ProductManager()), selectedCategory: .constant(nil), isDragging: .constant(false))
    }
}
