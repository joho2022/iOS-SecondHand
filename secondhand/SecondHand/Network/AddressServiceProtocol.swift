//
//  AddressServiceProtocol.swift
//  SecondHand
//
//  Created by 조호근 on 6/9/24.
//

import Foundation

protocol AddressServiceProtocol {
    func fetchRoadAddresses(keyword: String, page: Int, completion: @escaping (Result<[Address], NetworkError>) -> Void)
}
