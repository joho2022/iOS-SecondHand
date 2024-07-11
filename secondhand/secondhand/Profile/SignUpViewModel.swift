//
//  SignUpViewModel.swift
//  secondhand
//
//  Created by 조호근 on 6/4/24.
//

import SwiftUI
import os

class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var profileImage: UIImage?
    @Published var showSuccessView: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var showImagePicker: Bool = false
    @Published var showLocationSearch: Bool = false
    @Published var showUserNameTakenAlert: Bool = false
    @Published var selectedLocation: Address?
    
    private let userManager: UserSignUpProvider
    
    init(userManager: UserSignUpProvider) {
        self.userManager = userManager
    }
    
    func signUp() {
        guard !userManager.isUserNameTaken(username) else {
            showUserNameTakenAlert = true
            return
        }
        
        let user = createUserObject()
        os_log("[ 회원가입 ]: \(user)")
        
        do {
            try userManager.saveUser(user)
            showSuccessView = true
        } catch {
            showErrorAlert = true
        }
    }
    
    func loadImage(inputImage: UIImage?) {
        guard let inputImage = inputImage else { return }
        self.profileImage = inputImage
    }
    
    private func createUserObject() -> User {
        let user = User()
        user.username = self.username
        if let profileImage = self.profileImage {
            user.profileImageData = profileImage.pngData()
        }
        
        if let selectedLocation = self.selectedLocation {
            let location = Location()
            location.name = selectedLocation.roadAddr
            location.dongName = selectedLocation.emdNm
            location.isDefault = true
            user.locations.append(location)
        }
        return user
    }
}
