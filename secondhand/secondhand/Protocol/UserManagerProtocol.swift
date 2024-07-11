//
//  UserManagerProtocol.swift
//  secondhand
//
//  Created by 조호근 on 6/10/24.
//

import Foundation

protocol UserProvider {
    var user: User? { get set }
    var userPublisher: Published<User?>.Publisher { get }
}

protocol UserLoginProvider {
    func login(username: String) -> Bool
}

protocol UserUpdateProvider {
    func logout()
    func updateProfileImage(for username: String, with imageData: Data)
}

protocol UserLocationProvider {
    func addLocation(_ address: Address)
    func removeLocation(_ address: Address)
    func setDefaultLocation(location: Location)
}

protocol UserSignUpProvider {
    func isUserNameTaken(_ username: String) -> Bool
    func saveUser(_ user: User) throws
}
