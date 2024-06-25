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
        filterProducts()
    }
    
    private func setupBindings() {
        userManager?.userPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.filterProducts()
            }
            .store(in: &cancellables)
        
        $selectedCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.filterProducts()
            }
            .store(in: &cancellables)
        
        productManager.productsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.filterProducts()
            }
            .store(in: &cancellables)
    }
    
    func setSelectedCategory(_ category: Category?) {
        selectedCategory = category
        filterProducts()
    }
    
    func filterProducts() {
        guard let userManager = userManager else { return }
        
        var filtered = productManager.getProducts()
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category.contains(category) }
        }
        
        if let location = selectedLocation {
            filtered = filtered.filter { $0.location == location.emdNm }
        } else if let user = userManager.user, let userLocation = user.locations.first(where: { $0.isDefault }) {
            filtered = filtered.filter { $0.location == userLocation.dongName }
        } else {
            filtered = filtered.filter { $0.location == "역삼동" }
        }
        
        filteredProducts = filtered
    }
}
