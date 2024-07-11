//
//  secondhandApp.swift
//  secondhand
//
//  Created by 조호근 on 6/3/24.
//

import SwiftUI

@main
struct secondhandApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var productManager = ProductManager()
    
    var body: some Scene {
        WindowGroup {
            if appState.realm != nil,
               let userManager = appState.userManager,
               let chatRoomViewModel = appState.chatRoomViewModel {
                ContentView()
                    .environmentObject(userManager)
                    .environmentObject(productManager)
                    .environmentObject(appState)
                    .environmentObject(chatRoomViewModel)
            } else {
                ProgressView("Connecting to Realm...")
            }
        }
    }
}
