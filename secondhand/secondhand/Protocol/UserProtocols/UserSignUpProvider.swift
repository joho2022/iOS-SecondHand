//
//  UserSignUpProvider.swift
//  secondhand
//
//  Created by 조호근 on 6/25/24.
//

import Foundation

protocol UserSignUpProvider {
    func isUserNameTaken(_ username: String) -> Bool
    func saveUser(_ user: User) throws
}
