//
//  ProductListViewModel.swift
//  secondhand
//
//  Created by 조호근 on 6/11/24.
//

import Foundation
import Combine

class ProductListViewModel: ObservableObject {
    @Published var filteredProducts: [Product] = []
    @Published var showloadErrorAlert: Bool = false
    @Published var selectedLocation: Address?
    @Published var selectedCategory: Category?
    
    private var userManager: UserProvider?
    @Published var productManager: ProductManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(userManager: UserProvider, productManager: ProductManagerProtocol) {
        self.userManager = userManager
        self.productManager = productManager
        setupBindings()
    }
    
    private func setupBindings() {
        userManager?.userPublisher
            .combineLatest(productManager.productsPublisher, $selectedCategory, $selectedLocation)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user, products, category, location in
                self?.filterProducts(user: user, products: products, category: category, location: location)
            }
            .store(in: &cancellables)
    }
    
    func setSelectedCategory(_ category: Category?) {
        selectedCategory = category
    }
    
    private func filterProducts(user: User?, products: [Product], category: Category?, location: Address?) {
        var filtered = products
        
        if let category = category {
            filtered = filtered.filter { $0.category.contains(category) }
        }
        
        if let location = location {
            filtered = filtered.filter { $0.location == location.emdNm }
        } else if let user = user, let userLocation = user.locations.first(where: { $0.isDefault }) {
            filtered = filtered.filter { $0.location == userLocation.dongName }
        } else {
            filtered = filtered.filter { $0.location == "역삼동" }
        }
        
        filteredProducts = filtered
    }
}
