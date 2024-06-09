//
//  UserManagerProtocol.swift
//  secondhand
//
//  Created by 조호근 on 6/10/24.
//

import Foundation

protocol UserManagerProtocol {
    var user: User? { get set }
    var showAlert: Bool { get set }
    var alertMessage: String { get set }
    
    func login(username: String) -> Bool
    func logout()
    func isUserNameTaken(_ username: String) -> Bool
    func updateProfileImage(for username: String, with imageData: Data)
    func saveUser(_ user: User) throws
}
