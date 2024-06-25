//
//  ProductListViewModelTests.swift
//  secondhandTests
//
//  Created by 조호근 on 6/17/24.
//

import XCTest
import Combine
@testable import secondhand

final class MockUserProvider: UserProvider {
    @Published var user: User?
    var userPublisher: Published<secondhand.User?>.Publisher {
        $user
    }
}

class MockProductManager: ProductManagerProtocol {
    @Published var products: [Product] = []
    
    var productsPublisher: Published<[Product]>.Publisher { $products }
    
    func loadMockProducts() {
        guard let url = Bundle.main.url(forResource: "Products", withExtension: "json") else {
            XCTFail("Missing file: Products.json")
            return
        }
        
        let data = try! Data(contentsOf: url)
        let products = try! JSONDecoder().decode([Product].self, from: data)
        
        self.products = products
    }
    
    func getProducts() -> [Product] {
        return products
    }
    
    func addProduct(_ product: Product) {
        products.append(product)
    }
    
    func getNextProductId() -> Int {
        return (products.map { $0.id }.max() ?? 0) + 1
    }
}

final class ProductListViewModelTests: XCTestCase {
    var viewModel: ProductListViewModel!
    var productManager: MockProductManager!
    var userManager: MockUserProvider!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        userManager = MockUserProvider()
        productManager = MockProductManager()
        viewModel = ProductListViewModel(userManager: userManager, productManager: productManager)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        productManager = nil
        userManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_LoadProducts() {
        let expectation = XCTestExpectation(description: "Products loaded")
        
        productManager.loadMockProducts()
        
        productManager.$products
            .sink { products in
                XCTAssertFalse(products.isEmpty, "Mock 데이터가 있어야 한다.")
                
                XCTAssertEqual(self.viewModel.filteredProducts.count, products.count, "로드된 데이터 수가 일치해야 한다.")
                
                for (index, product) in products.enumerated() {
                    XCTAssertEqual(self.viewModel.filteredProducts[index].title, product.title, "제품 이름이 일치해야 합니다.")
                }
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_filterProducts() {
        let expectation = XCTestExpectation(description: "Products filtered by selected location")
        let location = Address(roadAddr: "역삼동", emdNm: "역삼동")
        viewModel.selectedLocation = location
        
        viewModel.$filteredProducts
            .dropFirst()
            .sink { products in
                XCTAssertEqual(products.count, self.viewModel.filteredProducts.count, "선택된 동네에 상품 필터링 확인한다.")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.filterProducts()
        
        self.wait(for: [expectation], timeout: 5.0)
    }
}
