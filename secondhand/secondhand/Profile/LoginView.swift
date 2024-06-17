//
//  LoginView.swift
//  secondhand
//
//  Created by 조호근 on 6/4/24.
//

import SwiftUI
import os

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                HStack(spacing: 30) {
                    Text("아이디")
                    TextField("아이디를 입력하세요", text: $viewModel.username)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
                .padding(.top, 90)
                
                Divider()
                
                Spacer()
                
                Button {
                    viewModel.login()
                } label: {
                    Text("로그인")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.customWhite)
                        .background(.customOrange)
                        .cornerRadius(8)
                        .font(.system(size: 15, weight: .regular))
                }
                .padding()
                
                Button {
                    viewModel.showSignUpView = true
                } label: {
                    Text("회원가입")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.customGray900)
                }
                .padding(.bottom, 90)
                .sheet(isPresented: $viewModel.showSignUpView, content: {
                    SignUpView(viewModel: SignUpViewModel(userManager: viewModel.getUserManager()))
                })
            }
            .navigationBarTitle("내 계정", displayMode: .inline)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("오류"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("확인")))
            }
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(userManager: UserManager()))
}
