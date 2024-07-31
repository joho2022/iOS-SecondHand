//
//  AddressServiceTests.swift
//  SecondHandTests
//
//  Created by 조호근 on 6/8/24.
//

import XCTest
@testable import SecondHand

final class AddressServiceTests: XCTestCase {
    var addressService: AddressService!
    
    override func setUp() {
        super.setUp()
        addressService = AddressService()
    }
    
    override func tearDown() {
        addressService = nil
        super.tearDown()
    }
    
    func test_FetchRoadAddresses() {
        let expectation = self.expectation(description: "Fetching addresses")
        
        addressService.fetchRoadAddresses(keyword: "호매실", page: 1) { result in
            switch result {
            case .success(let addresses):
                XCTAssertFalse(addresses.isEmpty)
                XCTAssert(addresses.map { $0.roadAddr.contains("호매실") }.count == 20 )
                expectation.fulfill()
            case .failure(let error):
                XCTFail("[테스트 에러]: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 10)
    }
}
