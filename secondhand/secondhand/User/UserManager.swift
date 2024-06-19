//
//  UserManager.swift
//  secondhand
//
//  Created by 조호근 on 6/5/24.
//

import Combine
import RealmSwift
import os
import Foundation

class UserManager: ObservableObject, UserProvider, UserLoginProvider, UserUpdateProvider, UserSignUpProvider, UserLocationProvider {
    @Published var user: User?
    var userPublisher: Published<User?>.Publisher {
        $user
    }
    
    private func refreshUser() {
        if let username = user?.username {
            self.user = RealmManager.shared.fetchUser(by: username)
        }
    }
    
    func login(username: String) -> Bool {
        if let fetchedUser = RealmManager.shared.fetchUser(by: username) {
            self.user = fetchedUser
            return true
        } else {
            os_log("[ 로그인 실패 ]: 유저정보가 없음")
        }
        return false
    }
    
    func logout() {
        self.user = nil
    }
    
    func isUserNameTaken(_ username: String) -> Bool {
        return RealmManager.shared.fetchUser(by: username) != nil
    }
    
    func updateProfileImage(for username: String, with imageData: Data) {
        let realm = try! Realm()
        if let user = RealmManager.shared.fetchUser(by: username) {
            try! realm.write {
                user.profileImageData = imageData
            }
            self.user = user
        } else {
            os_log(.error, "[ 사진 업데이트 실패 ]: 유저정보 없음")
        }
    }
    
    func saveUser(_ user: User) {
        RealmManager.shared.saveUser(user)
    }
    
    func addLocation(_ address: Address) {
        guard let user = user else { return }
        let location = Location()
        location.name = address.roadAddr
        location.dongName = address.emdNm
        RealmManager.shared.addLocation(to: user, location: location)
        refreshUser()
    }
    
    func removeLocation(_ address: Address) {
        guard let user = user else { return }
        if let location = user.locations.first(where: { $0.dongName == address.emdNm && $0.name == address.roadAddr }) {
            RealmManager.shared.removeLocation(from: user, location: location)
            
            if location.isDefault {
                if let newDefaultLocation = user.locations.first {
                    setDefaultLocation(location: newDefaultLocation)
                }
            }
            
            refreshUser()
        }
    }
    
    func getDefaultLocation() -> Location {
        if let user = user, let defaultLocation = user.locations.first(where: { $0.isDefault }) {
            return defaultLocation
        } else {
            return Location(name: "로그인 이전 기본값", dongName: "역삼동", isDefault: true)
        }
    }
    
    func setDefaultLocation(location: Location) {
        guard let user = user else { return }
        
        RealmManager.shared.setDefaultLocation(for: user, location: location)
        refreshUser()
    }
}
