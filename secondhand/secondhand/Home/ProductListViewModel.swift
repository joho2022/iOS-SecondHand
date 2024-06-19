//
//  ProductListViewModel.swift
//  secondhand
//
//  Created by 조호근 on 6/11/24.
//

import Foundation
import Combine

class ProductListViewModel: ObservableObject {
    private(set) var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var showloadErrorAlert: Bool = false
    @Published var selectedLocation: Address?
    @Published var selectedCategory: Category?
    
    private var userManager: UserProvider?
    private var cancellables = Set<AnyCancellable>()
    
    init(userManager: UserProvider) {
        self.userManager = userManager
        loadProducts()
        setupBindings()
    }
    
    private func setupBindings() {
        userManager?.userPublisher
            .sink { [weak self] _ in
                self?.filterProducts()
            }
            .store(in: &cancellables)
        
        $selectedCategory
            .sink { [weak self] _ in
                self?.filterProducts()
            }
            .store(in: &cancellables)
    }
    
    func loadProducts() {
        guard let url = Bundle.main.url(forResource: "Products", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let products = try? JSONDecoder().decode([Product].self, from: data) else {
            showloadErrorAlert = true
            return
        }
        printPrettyJSON(products: products)
        self.products = products
    }
    
    func setSelectedCategory(_ category: Category?) {
        selectedCategory = category
        filterProducts()
    }
    
    func filterProducts() {
        guard let userManager = userManager else { return }
        
        var filtered = products
        
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
    
    private func printPrettyJSON(products: [Product]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(products)
            // swiftlint:disable:next non_optional_string_data_conversion
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)                
            }
        } catch {
            print("Failed to encode products to JSON: \(error)")
        }
    }
}
