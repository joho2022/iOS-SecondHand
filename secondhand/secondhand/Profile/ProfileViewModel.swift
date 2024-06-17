//
//  ProfileViewModel.swift
//  secondhand
//
//  Created by 조호근 on 6/17/24.
//

import SwiftUI
import os

class ProfileViewModel: ObservableObject {
    @Published var profileImage: UIImage?
    @Published var username: String?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showImagePicker: Bool = false
    @Published var inputImage: UIImage?
    
    private let userManager: (UserProvider & UserUpdateProvider)
    
    init(userManager: (UserProvider & UserUpdateProvider)) {
        self.userManager = userManager
        loadProfileData()
    }
    
    func logout() {
        userManager.logout()
    }
    
    func updateProfileImage() {
        guard let inputImage = inputImage else {
            showAlert = true
            alertMessage = "이미지를 선택해주세요."
            return
        }
        if let imageData = inputImage.pngData(), let username = userManager.user?.username {
            userManager.updateProfileImage(for: username, with: imageData)
            loadProfileData()
        } else {
            showAlert = true
            alertMessage = "프로필 이미지 업데이트에 실패했습니다."
        }
    }
    
    private func loadProfileData() {
        guard let user = userManager.user else {
            os_log(.error, "[에러]: loadProfileData()")
            return
        }
        
        self.username = user.username
        if let profileImageData = user.profileImageData {
            self.profileImage = UIImage(data: profileImageData)
        } else {
            self.profileImage = nil
        }
    }
}
