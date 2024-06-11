//
//  ProductListView.swift
//  secondhand
//
//  Created by 조호근 on 6/11/24.
//

import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.products, id: \.id) { product in
                        ProductRow(product: product)
                    }
                } // LazyVStack
            } // ScrollView
        } // NavigationView
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
