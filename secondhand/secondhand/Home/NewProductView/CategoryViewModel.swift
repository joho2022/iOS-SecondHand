//
//  CategoryViewModel.swift
//  secondhand
//
//  Created by 조호근 on 6/21/24.
//

import Combine

class CategoryViewModel: ObservableObject {
    @Published var selectedCategory: Category?
    @Published var randomCategories: [Category] = []
    @Published var title: String = ""
    
    func selectCategory(_ category: Category) {
        selectedCategory = category
    }
    
    func generateRandomCategories() {
        randomCategories = Category.allCases.shuffled().prefix(3).map { $0 }
    }
}
