//
//  User.swift
//  secondhand
//
//  Created by 조호근 on 6/4/24.
//

import RealmSwift
import Foundation
import os

class User: Object {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted var username: String = ""
    @Persisted var profileImageData: Data?
    @Persisted var locations = List<Location>()
}

class Location: Object {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var dongName: String = ""
    @Persisted var isDefault: Bool = false
    
    required override init() {
        super.init()
    }

    init(name: String, dongName: String, isDefault: Bool) {
        self.name = name
        self.dongName = dongName
        self.isDefault = isDefault
    }
}
