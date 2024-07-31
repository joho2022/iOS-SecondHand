//
//  UserFavoriteProvider.swift
//  SecondHand
//
//  Created by 조호근 on 7/6/24.
//

import Foundation

protocol UserFavoriteProvider {
    func addLikedProduct(_ productId: Int)
    func removeLikedProduct(_ productId: Int)
}
