//
//  ProductListViewModel.swift
//  secondhand
//
//  Created by 조호근 on 6/11/24.
//

import Foundation

class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var showloadErrorAlert: Bool = false
    
    init() {
        loadProducts()
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
