//
//  Product.swift
//  secondhand
//
//  Created by 조호근 on 6/10/24.
//

import Foundation

struct Product: Identifiable, Codable {
    let id: Int
    var title: String
    var price: Int
    var location: String
    var category: [Category]
    var image: String
    let timePosted: String
    var likes: Int
    var comments: Int
    var isReserved: Bool
}
