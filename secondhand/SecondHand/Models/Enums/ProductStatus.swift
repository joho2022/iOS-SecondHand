//
//  ProductStatus.swift
//  SecondHand
//
//  Created by 조호근 on 7/7/24.
//

import Foundation

enum ProductStatus: String, Codable {
    case selling = "판매중"
    case reserved = "예약중"
    case soldOut = "판매완료"
}
