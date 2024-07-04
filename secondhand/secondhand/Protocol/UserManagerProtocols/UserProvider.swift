//
//  UserProvider.swift
//  secondhand
//
//  Created by 조호근 on 6/10/24.
//

import Foundation

protocol UserProvider {
    var user: User? { get set }
    var userPublisher: Published<User?>.Publisher { get }
}
