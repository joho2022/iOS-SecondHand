//
//  ProfileView.swift
//  secondhand
//
//  Created by 조호근 on 6/8/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                Button {
                    viewModel.showImagePicker = true
                } label: {
                    ZStack {
                        if let profileImage = viewModel.profileImage {
                            Image(uiImage: profileImage)
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
                .sheet(isPresented: $viewModel.showImagePicker, onDismiss: viewModel.updateProfileImage, content: {
                    ImagePicker(image: $viewModel.inputImage)
                })
                
                Text(viewModel.username ?? "사용자 이름")
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.horizontal)
                    .padding(.top, 30)
                
                Spacer()
                
                Button {
                    viewModel.logout()
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
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("오류"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("확인"))
                )
            }
        } // NavigationView
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(userManager: UserManager()))
}
