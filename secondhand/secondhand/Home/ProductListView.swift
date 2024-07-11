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
    
    init(viewModel: ProductListViewModel, selectedCategory: Binding<Category?>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._selectedCategory = selectedCategory
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredProducts, id: \.id) { product in
                        ProductRow(product: product)
                    }
                } // LazyVStack
            } // ScrollView
            .onChange(of: selectedCategory) { newCategory in
                viewModel.setSelectedCategory(newCategory)
            }
        } // NavigationView
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(viewModel: ProductListViewModel(userManager: UserManager()), selectedCategory: .constant(nil))
    }
}
