//
//  ContentView.swift
//  secondhand
//
//  Created by 조호근 on 6/3/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈화면")
                        .font(.system(.regular, size: 17))
                }
            SalesHistoryView()
                .tabItem {
                    Image(systemName: "doc.plaintext")
                    Text("판매내역")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("관심목록")
                }
            ChatView()
                .tabItem {
                    Image(systemName: "message")
                    Text("채팅")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("내 계정")
                }
        }
        .tint(.orange)
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
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

struct HomeView: View {
    var body: some View {
        Text("홈화면")
    }
}

struct SalesHistoryView: View {
    var body: some View {
        Text("판매내역")
    }
}

struct FavoritesView: View {
    var body: some View {
        Text("관심목록")
    }
}

struct ChatView: View {
    var body: some View {
        Text("채팅")
    }
}

#Preview {
    ProfileView()
}
