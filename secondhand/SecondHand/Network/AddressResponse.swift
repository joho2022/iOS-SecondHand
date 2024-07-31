//
//  Juso.swift
//  SecondHand
//
//  Created by 조호근 on 6/5/24.
//

import Foundation

struct AddressResponse: Codable {
    let results: AddressResults
}

struct AddressResults: Codable {
    let common: Common
    let addresses: [Address]
    
    enum CodingKeys: String, CodingKey {
        case common
        case addresses = "juso"
    }
}

struct Common: Codable {
    let totalCount: String
    let errorCode: String
    let errorMessage: String
}

struct Address: Codable, Equatable, Hashable {
    let roadAddr: String
    let emdNm: String
    
    init(roadAddr: String, emdNm: String) {
        self.roadAddr = roadAddr
        self.emdNm = emdNm
    }
    
    init(from location: Location) {
        self.roadAddr = location.name
        self.emdNm = location.dongName
    }
    
    static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.roadAddr == rhs.roadAddr && lhs.emdNm == rhs.emdNm
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(roadAddr)
        hasher.combine(emdNm)
    }
}
