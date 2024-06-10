//
//  SignUpViewModelTests.swift
//  secondhandTests
//
//  Created by 조호근 on 6/10/24.
//

import XCTest
import Combine
@testable import secondhand

final class MockUserManager: UserManagerProtocol {
    @Published var user: User?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    var users: [String: User] = [:]
    
    func login(username: String) -> Bool {
        if let fetchedUser = users[username] {
            self.user = fetchedUser
            return true
        }
        return false
    }
    
    func logout() {
        self.user = nil
    }
    
    func isUserNameTaken(_ username: String) -> Bool {
        return users[username] != nil
    }
    
    func updateProfileImage(for username: String, with imageData: Data) {
        if let user = users[username] {
            user.profileImageData = imageData
            self.user = user
            users[username] = user
        }
    }
    
    func saveUser(_ user: User) throws {
        if isUserNameTaken(user.username) {
            throw NSError(domain: "User already exists", code: -1)
        }
        users[user.username] = user
        self.user = user
    }
}

final class SignUpViewModelTests: XCTestCase {
    var viewModel: SignUpViewModel!
    var mockUserManager: MockUserManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUserManager = MockUserManager()
        viewModel = SignUpViewModel(userManager: mockUserManager)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserManager = nil
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
                XCTAssertEqual(self.mockUserManager.user?.username, "testUser")
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
        try! mockUserManager.saveUser(existingUser)
        
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
