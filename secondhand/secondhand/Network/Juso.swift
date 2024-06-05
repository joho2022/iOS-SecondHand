//
//  Juso.swift
//  secondhand
//
//  Created by 조호근 on 6/5/24.
//

import Foundation

struct JusoResponse: Codable {
    let results: JusoResults
    
    struct JusoResults: Codable {
        let common: Common
        let juso: [Juso]
    }
    
    struct Common: Codable {
        let totalCount: String
        let errorCode: String
        let errorMessage: String
    }
    
    struct Juso: Codable {
        let roadAddr: String
    }
}
