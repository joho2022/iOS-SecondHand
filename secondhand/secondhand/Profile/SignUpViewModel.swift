//
//  SignUpViewModel.swift
//  secondhand
//
//  Created by 조호근 on 6/4/24.
//

import SwiftUI
import RealmSwift

class SignUpViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var locationName: String = ""
    @Published var profileImage: UIImage?
    @Published var showSuccessView: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var showImagePicker: Bool = false
    @Published var showLocationSearch: Bool = false
    
    func signUp() {
        let user = User()
        user.username = username
        
        if let profileImage = profileImage {
            user.profileImageData = profileImage.pngData()
        }
        
        let location = Location()
        location.name = locationName
        location.isDefault = true
        
        user.locations.append(location)
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(user)
            }
            showSuccessView = true
        } catch {
            showErrorAlert = true
        }
    }
    
    func loadImage(inputImage: UIImage?) {
        guard let inputImage = inputImage else { return }
        self.profileImage = inputImage
    }
}