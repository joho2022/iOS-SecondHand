//
//  UserLoginProvider.swift
//  secondhand
//
//  Created by 조호근 on 6/25/24.
//

import Foundation

protocol UserLoginProvider {
    func login(username: String) -> Bool
}
