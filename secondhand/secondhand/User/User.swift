//
//  User.swift
//  secondhand
//
//  Created by 조호근 on 6/4/24.
//

import RealmSwift
import Foundation

class User: Object {
    @Persisted var id: String = UUID().uuidString
    @Persisted var username: String = ""
    @Persisted var profileImageData: Data?
    @Persisted var locations = List<Location>()
}

class Location: Object {
    @Persisted var name: String = ""
    @Persisted var isDefault: Bool = false
}
