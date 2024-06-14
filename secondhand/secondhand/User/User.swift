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
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var username: String = ""
    @Persisted var profileImageData: Data?
    @Persisted var locations = List<Location>()
}

class Location: Object {
    @Persisted var name: String = ""
    @Persisted var dongName: String = ""
    @Persisted var isDefault: Bool = false
}

extension User {
    private static var realm = try! Realm()
    
    func addLocation(_ location: Location) {
        do {
            try User.realm.write {
                if !self.locations.contains(location) {
                    self.locations.append(location)
                }
            }
        } catch {
            os_log(.error, "Realm에서 쓰기 실패: %{public}@", "\(error)")
        }
    }
    
    func removeLocation(_ location: Location) {
        do {
            try User.realm.write {
                if let index = self.locations.index(of: location) {
                    self.locations.remove(at: index)
                }
            }
        } catch {
            os_log(.error, "Realm에서 삭제 실패: %{public}@", "\(error)")
        }
    }
}
