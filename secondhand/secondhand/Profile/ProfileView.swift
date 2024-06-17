//
//  ProfileView.swift
//  secondhand
//
//  Created by 조호근 on 6/8/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                Button {
                    self.showImagePicker = true
                } label: {
                    ZStack {
                        if let profileImage = userManager.user?.profileImageData,
                           let uiImage = UIImage(data: profileImage) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.customGray500, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/))
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(.customGray500, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/))
                                .foregroundColor(.customOrange)
                        }
                        
                        Text("편집")
                            .font(.system(size: 11, weight: .regular))
                            .frame(width: 100)
                            .padding(2)
                            .padding(.bottom, 10)
                            .background(.customGray500)
                            .foregroundColor(.customWhite)
                            .clipShape(Capsule())
                            .offset(y: 30)
                        
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                } // Button
                .padding(.top, 90)
                .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
                    ImagePicker(image: $inputImage)
                })
                
                Text(userManager.user?.username ?? "사용자 이름")
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.horizontal)
                    .padding(.top, 30)
                
                Spacer()
                
                Button {
                    userManager.logout()
                } label: {
                    
                    Text("로그아웃")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.customWhite)
                        .background(.customOrange)
                        .cornerRadius(8)
                }
                .padding()
                .padding(.bottom, 121)

            } // VStack
            .navigationBarTitle("내 계정", displayMode: .inline)
        } // NavigationView
    }
    
    private func loadImage() {
        guard let inputImage = inputImage else { return }
        if let imageData = inputImage.pngData(), let username = userManager.user?.username {
            userManager.updateProfileImage(for: username, with: imageData)
        }
    }
}

#Preview {
    ProfileView().environmentObject(UserManager())
}
