//
//  Product.swift
//  secondhand
//
//  Created by 조호근 on 6/10/24.
//

import Foundation

enum ProductStatus: String, Codable {
    case selling = "판매중"
    case reserved = "예약중"
    case soldOut = "판매완료"
}

struct Product: Identifiable, Codable {
    let id: Int
    var title: String
    var price: Int
    var location: String
    var category: [Category]
    var images: [String]
    let timePosted: String
    var likes: Int
    var comments: Int
    var status: ProductStatus
    let user: String
    var description: String
    
    var imageURLs: [URL] {
        images.compactMap { imagePath in
            if imagePath.starts(with: "http") {
                return URL(string: imagePath)
            } else {
                return ImageManager.getImageURL(fileName: imagePath)
            }
        }
    }
}
