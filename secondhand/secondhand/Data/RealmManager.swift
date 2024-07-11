//
//  RealmManager.swift
//  secondhand
//
//  Created by 조호근 on 6/14/24.
//

import RealmSwift
import os
import Foundation

class RealmManager {
    
    private var realm: Realm?
    
    init(realm: Realm?) {
        self.realm = realm
    }
    
    private var safeRealm: Realm {
        guard let realm = realm else {
            fatalError("Realm 초기화 실패")
        }
        return realm
    }
    
    func fetchUser(by username: String) -> User? {
        return safeRealm.objects(User.self).filter("username == %@", username).first
    }
    
    func saveUser(_ user: User) {
        do {
            try safeRealm.write {
                safeRealm.add(user, update: .modified)
            }
        } catch {
            os_log(.error, "User 저장 실패: %{public}@", "\(error)")
        }
    }
    
    func updateUserImage(for user: User, with imageData: Data) {
        do {
            try safeRealm.write {
                user.profileImageData = imageData
            }
        } catch {
            os_log(.error, "프로필 이미지 업데이트 실패: %{public}@", "\(error)")
        }
    }
    
    func addLocation(to user: User, location: Location) {
        do {
            try safeRealm.write {
                if !user.locations.contains(location) {
                    user.locations.append(location)
                }
            }
        } catch {
            os_log(.error, "location 추가 실패: %{public}@", "\(error)")
        }
    }
    
    func removeLocation(from user: User, location: Location) {
        do {
            try safeRealm.write {
                if let index = user.locations.index(of: location) {
                    user.locations.remove(at: index)
                }
            }
        } catch {
            os_log(.error, "location 삭제 실패: %{public}@", "\(error)")
        }
    }
    
    func setDefaultLocation(for user: User, location: Location) {
        try! safeRealm.write {
            user.locations.forEach { $0.isDefault = false }
            if let index = user.locations.firstIndex(of: location ) {
                user.locations[index].isDefault = true
            }
        }
    }
}
