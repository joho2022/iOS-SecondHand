//
//  Product.swift
//  SecondHand
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
    var images: [String]
    let timePosted: String
    var likes: Int
    var comments: Int
    var views: Int
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
