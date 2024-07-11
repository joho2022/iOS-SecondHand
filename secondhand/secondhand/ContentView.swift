//
//  ContentView.swift
//  secondhand
//
//  Created by 조호근 on 6/3/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userManager: UserManager
    
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
            if userManager.user == nil {
                LoginView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("내 계정")
                    }
            } else {
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("내 계정")
                    }
            }
        }
        .tint(.orange)
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
    ContentView().environmentObject(UserManager.shared)
}
