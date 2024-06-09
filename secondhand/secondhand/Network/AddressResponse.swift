//
//  Juso.swift
//  secondhand
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

struct Address: Codable {
    let roadAddr: String
}
