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

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var user: User?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    func login(username: String) -> Bool {
        if let fetchedUser = fetchUser(byUserName: username) {
            self.user = fetchedUser
            return true
        } else {
            os_log("[ 로그인 실패 ]: 유저정보가 없음")
            alertMessage = "로그인 실패: 유저정보가 없습니다."
            showAlert = true
        }
        return false
    }
    
    func logout() {
        self.user = nil
    }
    
    func isUserNameTaken(_ username: String) -> Bool {
        return fetchUser(byUserName: username) != nil
    }
    
    func updateProfileImage(for username: String, with imageData: Data) {
        let realm = try! Realm()
        if let user = fetchUser(byUserName: username) {
            try! realm.write {
                user.profileImageData = imageData
            }
            self.user = user
        } else {
            os_log("[ 사진 업데이트 실패 ]: 유저정보 없음")
            alertMessage = "사진 업데이트 실패: 유저정보가 없습니다."
            showAlert = true
        }
    }
    
    private func fetchUser(byUserName username: String) -> User? {
        let realm = try! Realm()
        return realm.objects(User.self).filter("username == %@", username).first
    }
}
