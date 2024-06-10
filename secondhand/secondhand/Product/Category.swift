//
//  Category.swift
//  secondhand
//
//  Created by 조호근 on 6/10/24.
//

import Foundation

enum Category: String, Codable {
    case popular = "인기매물"
    case digitalDevices = "디지털기기"
    case furnitureInterior = "가구/인테리어"
    case children = "유아동"
    case womensClothing = "여성의류"
    case womensAccessories = "여성잡화"
    case mensFashion = "남성패션/잡화"
    case homeAppliances = "생활가전"
    case homeKitchen = "생활/주방"
    case processedFood = "가공식품"
    case sportsLeisure = "스포츠/레저"
    case hobbiesGamesMusic = "취미/게임/음악"
    case plants = "식물"
    case petSupplies = "반려동물용품"
    case ticketsCoupons = "티켓/교환권"
    case books = "도서"
    case childrenBooks = "유아도서"
    case otherUsedGoods = "기타 중고물품"
    case buying = "삽니다"
}
