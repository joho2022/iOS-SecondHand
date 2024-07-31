//
//  ProductManagerProtocol.swift
//  SecondHand
//
//  Created by 조호근 on 6/24/24.
//

import Foundation

protocol ProductManagerProtocol {
    var productsPublisher: Published<[Product]>.Publisher { get }
    func addProduct(_ product: Product)
    func getNextProductId() -> Int
}
