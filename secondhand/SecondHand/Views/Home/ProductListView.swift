//
//  ProductListView.swift
//  SecondHand
//
//  Created by 조호근 on 6/11/24.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var productManager: ProductManager
    @StateObject private var viewModel: ProductListViewModel
    @Binding var selectedCategory: Category?
    @Binding var isDragging: Bool
    @Binding var selectedProduct: Product?
    @Binding var isPresentingDetailView: Bool

    init(viewModel: ProductListViewModel, selectedCategory: Binding<Category?>, isDragging: Binding<Bool>, selectedProduct: Binding<Product?>, isPresentingDetailView: Binding<Bool>) {
            self._viewModel = StateObject(wrappedValue: viewModel)
            self._selectedCategory = selectedCategory
            self._isDragging = isDragging
            self._selectedProduct = selectedProduct
            self._isPresentingDetailView = isPresentingDetailView
        }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.filteredProducts, id: \.id) { product in
                    Button {
                        selectedProduct = product
                        isPresentingDetailView = true
                    } label: {
                        ProductRow(product: product)
                    }
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
        ProductListView(viewModel: ProductListViewModel(userManager: UserManager(realmManager: RealmManager(realm: nil)), productManager: ProductManager()), selectedCategory: .constant(nil), isDragging: .constant(false), selectedProduct: .constant(nil), isPresentingDetailView: .constant(false))
            .environmentObject(UserManager(realmManager: RealmManager(realm: nil)))
    }
}
