//
//  LocationSearchViewModelTests.swift
//  secondhandTests
//
//  Created by 조호근 on 6/9/24.
//

import XCTest
import Combine
@testable import secondhand

final class MockAddressService: AddressServiceProtocol {
    var result: Result<[Address], NetworkError>?
    
    func fetchRoadAddresses(keyword: String, page: Int, completion: @escaping (Result<[Address], secondhand.NetworkError>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}

final class LocationSearchViewModelTests: XCTestCase {
    var viewModel: LocationSearchViewModel!
    var mockService: MockAddressService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockAddressService()
        viewModel = LocationSearchViewModel(addressService: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_SearchQueryUpdateResults() {
        let expectation = XCTestExpectation(description: "Search results updated for 호매실")
        
        let mockResults = [
            Address(roadAddr: "경기도 수원시 권선구 호매실로 103 (호매실동, 호매실스타힐스)", emdNm: "호매실동"),
            Address(roadAddr: "경기도 수원시 권선구 호매실로90번길 86 (호매실동)", emdNm: "호매실동")
        ]
        mockService.result = .success(mockResults)
        
        viewModel.$searchResults
            .dropFirst()
            .sink { results in
                XCTAssertEqual(results, mockResults)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchQuery = "호매실"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.wait(for: [expectation], timeout: 2.0)
        }
    }
    
    func test_LoadMoreResults() {
        let expectation = XCTestExpectation(description: "Load more results for 호매실")
        
        let initialResults = [
            Address(roadAddr: "경기도 수원시 권선구 호매실로 103 (호매실동, 호매실스타힐스)", emdNm: "호매실동")
        ]
        mockService.result = .success(initialResults)
        viewModel.searchQuery = "호매실"
        
        let moreResults = [
            Address(roadAddr: "경기도 수원시 권선구 호매실로90번길 86 (호매실동)", emdNm: "호매실동")
        ]
        mockService.result = .success(moreResults)
        
        viewModel.$searchResults
            .dropFirst(2)
            .sink { results in
                XCTAssertEqual(results, initialResults + moreResults)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadMoreResult()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.wait(for: [expectation], timeout: 2.0)
        }
    }
    
    func test_SearchError() {
        let expectation = XCTestExpectation(description: "Handle search error for 호매실")
        
        mockService.result = .failure(.networkFailed(NSError(domain: "", code: -1)))
        
        viewModel.$searchResults
            .dropFirst()
            .sink { results in
                XCTAssertTrue(results.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchQuery = "호매실"
        
        self.wait(for: [expectation], timeout: 2.0)
    }
}
