//
//  LoginViewModel.swift
//  secondhand
//
//  Created by 조호근 on 6/17/24.
//

import SwiftUI
import os

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var showSignUpView: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let userManager: (UserProvider & UserLoginProvider & UserSignUpProvider)
    
    init(userManager: (UserProvider & UserLoginProvider & UserSignUpProvider)) {
        self.userManager = userManager
    }
    
    func login() {
        if userManager.login(username: username) {
            os_log("[ 로그인 성공 ] : 현재 유저 정보\n\(String(describing: self.userManager.user))")
        } else {
            showAlert = true
            alertMessage = "로그인 실패: 유저정보가 없습니다."
        }
    }
    
    func getUserManager() -> UserSignUpProvider {
        return userManager
    }
}
