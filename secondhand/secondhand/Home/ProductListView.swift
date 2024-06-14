//
//  ProductListView.swift
//  secondhand
//
//  Created by 조호근 on 6/11/24.
//

import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel: ProductListViewModel
    
    init(userManager: UserManager) {
        _viewModel = StateObject(wrappedValue: ProductListViewModel(userManager: userManager))
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
            .onAppear {
                viewModel.filterProducts()
            }
        } // NavigationView
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(userManager: UserManager())
    }
}
