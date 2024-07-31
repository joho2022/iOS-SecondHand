//
//  ProductDetailViewModel.swift
//  SecondHand
//
//  Created by 조호근 on 7/5/24.
//

import Foundation

class ProductDetailViewModel: ObservableObject {
    @Published private(set) var product: Product
    @Published private(set) var isFavorite: Bool
    @Published var showAlert: Bool = false
    @Published var showDeleteAlert: Bool = false
    @Published var isPresentingEditView: Bool = false
    var isSeller: Bool
    private var productManager: ProductManager
    private var userManager: (UserProvider & UserFavoriteProvider)
    
    init(product: Product, isSeller: Bool, productManager: ProductManager, userManager: (UserProvider & UserFavoriteProvider)) {
        self.product = product
        self.isFavorite = false
        self.isSeller = isSeller
        self.productManager = productManager
        self.userManager = userManager
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        updateFavoriteStatus()
    }
    
    private func updateFavoriteStatus() {
        guard (userManager.user) != nil else { return }
        if isFavorite {
            userManager.addLikedProduct(product.id)
        } else {
            userManager.removeLikedProduct(product.id)
        }
    }
    
    func updateProductStatus(to status: ProductStatus) {
        product.status = status
        productManager.updateProduct(product)
    }
    
    func deleteProduct() {
        productManager.deleteProduct(product)
    }
    
    func modifyProduct() {
        isPresentingEditView = true
    }
}
