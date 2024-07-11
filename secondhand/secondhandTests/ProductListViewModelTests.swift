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
        let mockProducts: [Product] = [
            Product(id: 0, title: "나이키 티셔츠", price: 40000, location: "역삼동", category: [.popular], image: "https://kream-phinf.pstatic.net/MjAyMzA0MTRfMjAw/MDAxNjgxNDUxNDAyMTUz.5q0cKoTNu0T3fLSHXHRomwuYI5EE3bxDXCcjHFeZnuUg.ts4o7ZUeK19uolxTSWNmVNDCr_mg9472IQ0YZcj0heIg.JPEG/a_d7263afeb4e04111abafbda2b5b67bea.jpg?type=l_webp", timePosted: "2024-06-10T13:14:08", likes: 10, comments: 2, isReserved: false, user: "100", description: "멋진 나이키 티셔츠입니다."),
            Product(id: 1, title: "조던 신발", price: 500000, location: "역삼동", category: [.popular], image: "https://kream-phinf.pstatic.net/MjAyNDA1MjRfMzkg/MDAxNzE2NTMyODQzNTgy.ECw3Xikv8w6R1-zs-OcQyVY-SMAN1tSInutYzMkUmNkg.cI4OQfPajMr34SNzLX32WaNQopL02vNol6_yWMQyl8gg.PNG/a_0a36d3746db04595871a75bcc6798e02.png?type=l_webp", timePosted: "2024-06-10T13:14:08", likes: 25, comments: 5, isReserved: false, user: "101", description: "새로운 조던 신발입니다.")
        ]
        
        self.products = mockProducts
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
        
        viewModel.$filteredProducts
            .dropFirst()
            .sink { filteredProducts in
                XCTAssertFalse(filteredProducts.isEmpty, "Mock 데이터가 있어야 한다.")
                
                let mockProducts = self.productManager.getProducts()
                XCTAssertEqual(filteredProducts.count, mockProducts.count, "로드된 데이터 수가 일치해야 한다.")
                
                for (index, product) in mockProducts.enumerated() {
                    XCTAssertEqual(filteredProducts[index].title, product.title, "제품 이름이 일치해야 합니다.")
                }
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.filterProducts()
        
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
