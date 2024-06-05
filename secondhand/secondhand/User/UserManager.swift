//
//  UserManager.swift
//  secondhand
//
//  Created by 조호근 on 6/5/24.
//

import Combine
import RealmSwift
import os

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var user: User?
    
    func login(username: String) -> Bool {
        if let fetchedUser = fetchUser(byUserName: username) {
            self.user = fetchedUser
            return true
        } else {
            os_log("[ 로그인 실패 ]: 유저정보가 없음")
        }
        return false
    }
    
    func isUserNameTaken(_ username: String) -> Bool {
        return fetchUser(byUserName: username) != nil
    }
    
    private func fetchUser(byUserName username: String) -> User? {
        let realm = try! Realm()
        return realm.objects(User.self).filter("username == %@", username).first
    }
}
