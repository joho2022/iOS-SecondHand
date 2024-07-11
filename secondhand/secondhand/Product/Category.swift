//
//  Category.swift
//  secondhand
//
//  Created by 조호근 on 6/10/24.
//

import Foundation

enum Category: String, Codable, CaseIterable {
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
    
    var imageName: String {
        switch self {
        case .popular:
            return "icon_popular"
        case .digitalDevices:
            return "icon_digitalDevices"
        case .furnitureInterior:
            return "icon_furnitureInterior"
        case .children:
            return "icon_children"
        case .womensClothing:
            return "icon_womensClothing"
        case .womensAccessories:
            return "icon_womensAccessories"
        case .mensFashion:
            return "icon_mensFashion"
        case .homeAppliances:
            return "icon_homeAppliances"
        case .homeKitchen:
            return "icon_homeKitchen"
        case .processedFood:
            return "icon_processedFood"
        case .sportsLeisure:
            return "icon_sportsLeisure"
        case .hobbiesGamesMusic:
            return "icon_hobbiesGamesMusic"
        case .plants:
            return "icon_plants"
        case .petSupplies:
            return "icon_petSupplies"
        case .ticketsCoupons:
            return "icon_ticketsCoupons"
        case .books:
            return "icon_books"
        case .childrenBooks:
            return "icon_childrenBooks"
        case .otherUsedGoods:
            return "icon_otherUsedGoods"
        case .buying:
            return "icon_buying"
        }
    }
}
