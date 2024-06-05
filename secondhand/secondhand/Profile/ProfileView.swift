//
//  ProfileView.swift
//  secondhand
//
//  Created by 조호근 on 6/4/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                HStack(spacing: 30) {
                    Text("아이디")
                    TextField("아이디를 입력하세요", text: .constant(""))
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
                .padding(.top, 90)
                
                Divider()
                
                Spacer()
                
                Button {
                    print("로그인")
                } label: {
                    Text("로그인")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.customWhite)
                        .background(.customOrange)
                        .cornerRadius(8)
                        .font(.system(.regular, size: 15))
                }
                .padding()
                
                Button {
                    print("회원가입")
                } label: {
                    Text("회원가입")
                        .font(.system(.regular, size: 15))
                        .foregroundColor(.customGray900)
                }
                .padding(.bottom, 90)
            }
            .navigationBarTitle("내 계정", displayMode: .inline)
        }
    }
}

#Preview {
    ProfileView()
}
