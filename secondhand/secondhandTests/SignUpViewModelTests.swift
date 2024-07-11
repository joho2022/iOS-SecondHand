//
//  SignUpViewModelTests.swift
//  secondhandTests
//
//  Created by 조호근 on 6/10/24.
//

import XCTest
import Combine
@testable import secondhand

final class MockUserSignUpProvider: UserSignUpProvider {
    var user: User?
    var users: [String: User] = [:]
    
    func isUserNameTaken(_ username: String) -> Bool {
        return users[username] != nil
    }
    
    func saveUser(_ user: secondhand.User) throws {
        if isUserNameTaken(user.username) {
            throw NSError(domain: "User already exists", code: -1)
        }
        users[user.username] = user
        self.user = user
    }
}

final class SignUpViewModelTests: XCTestCase {
    var viewModel: SignUpViewModel!
    var mockUserSignUpProvider: MockUserSignUpProvider!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUserSignUpProvider = MockUserSignUpProvider()
        viewModel = SignUpViewModel(userManager: mockUserSignUpProvider)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserSignUpProvider = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_SignUpSuccess() {
        let expectation = XCTestExpectation(description: "Sign-up successful")
        
        viewModel.username = "testUser"
        
        viewModel.$showSuccessView
            .dropFirst()
            .sink { success in
                XCTAssertTrue(success)
                XCTAssertEqual(self.mockUserSignUpProvider.user?.username, "testUser")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.signUp()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.wait(for: [expectation], timeout: 2.0)
        }
    }
    
    func test_SignUpUsernameTaken() {
        let expectation = XCTestExpectation(description: "Sign-up failed due to duplicate username")
        
        let existingUser = User()
        existingUser.username = "testUser"
        try! mockUserSignUpProvider.saveUser(existingUser)
        
        viewModel.username = "testUser"
        viewModel.$showUserNameTakenAlert
            .dropFirst()
            .sink { isTaken in
                XCTAssertTrue(isTaken)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.signUp()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.wait(for: [expectation], timeout: 2.0)
        }
    }
}
