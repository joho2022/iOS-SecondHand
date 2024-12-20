//
//  ProductManager.swift
//  SecondHand
//
//  Created by 조호근 on 6/23/24.
//

import Foundation
import Combine
import os

class ProductManager: ObservableObject, ProductManagerProtocol {
    @Published private var products: [Product] = []
    var productsPublisher: Published<[Product]>.Publisher { $products }
    
    init() {
        loadProducts()
    }
    
    private var documentsURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var productsFileURL: URL {
        return documentsURL.appendingPathComponent("Products.json")
    }
    
    private func loadProducts() {
        let url = productsFileURL
        
        if let data = try? Data(contentsOf: url),
           let decodedProducts = try? JSONDecoder().decode([Product].self, from: data) {
            self.products = decodedProducts
        } else {
            loadDefaultProducts()
        }
    }
    
    private func loadDefaultProducts() {
        if let url = Bundle.main.url(forResource: "Products", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedProducts = try? JSONDecoder().decode([Product].self, from: data) {
            self.products = decodedProducts
        }
    }
    
    func addProduct(_ product: Product) {
        products.append(product)
        saveProducts()
    }
    
    func updateProduct(_ product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index] = product
            saveProducts()
        }
    }
    
    func deleteProduct(_ product: Product) {
        products.removeAll { $0.id == product.id }
        saveProducts()
    }
    
    private func saveProducts() {
        let url = productsFileURL
        if let data = try? JSONEncoder().encode(products) {
            try? data.write(to: url)
        }
    }
    
    func getNextProductId() -> Int {
        return (products.map { $0.id }.max() ?? 0) + 1
    }
    
    func getProduct(byId id: Int) -> Product? {
        return products.first { $0.id == id }
    }
    
    private func printPrettyJSON(products: [Product]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(products)
            // swiftlint:disable:next non_optional_string_data_conversion
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                os_log(.info, "Products JSON: %@", jsonString)
            }
        } catch {
            os_log(.error, "Failed to encode products to JSON: %@", error.localizedDescription)
        }
    }
}
