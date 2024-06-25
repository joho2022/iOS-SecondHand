//
//  UserUpdateProvider.swift
//  secondhand
//
//  Created by 조호근 on 6/25/24.
//

import Foundation

protocol UserUpdateProvider {
    func logout()
    func updateProfileImage(for username: String, with imageData: Data)
}
