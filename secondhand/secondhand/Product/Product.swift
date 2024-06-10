//
//  Product.swift
//  secondhand
//
//  Created by 조호근 on 6/10/24.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let price: Int
    let location: String
    let category: [Category]
    let image: String
    let timePosted: String
}
