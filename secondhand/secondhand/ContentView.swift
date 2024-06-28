//
//  ContentView.swift
//  secondhand
//
//  Created by 조호근 on 6/3/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈화면")
                        .font(.system(size: 17, weight: .regular))
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
            if userManager.user == nil {
                LoginView(viewModel: LoginViewModel(userManager: userManager))
                    .tabItem {
                        Image(systemName: "message")
                        Text("채팅")
                    }
            } else {
                ChatListView()
                    .tabItem {
                        Image(systemName: "message")
                        Text("채팅")
                    }
                    .onAppear {
                        print("ChatListView on Appear")
                        if let currentUser = userManager.user {
                            appState.chatRoomViewModel?.fetchChatRooms(for: currentUser)
                        }
                    }
            }
            if userManager.user == nil {
                LoginView(viewModel: LoginViewModel(userManager: userManager))
                    .tabItem {
                        Image(systemName: "person")
                        Text("내 계정")
                    }
            } else {
                ProfileView(viewModel: ProfileViewModel(userManager: userManager))
                    .tabItem {
                        Image(systemName: "person")
                        Text("내 계정")
                    }
            }
        }
        .tint(.orange)
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

#Preview {
    ContentView().environmentObject(UserManager(realmManager: RealmManager(realm: nil)))
        .environmentObject(ProductManager())
}
