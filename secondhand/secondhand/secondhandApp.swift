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
            if let realm = appState.realm {
                let realmManager = RealmManager(realm: realm)
                let userManager = UserManager(realmManager: realmManager)
                ContentView()
                    .environmentObject(userManager)
                    .environmentObject(productManager)
            } else {
                ProgressView("Connecting to Realm...")
            }
        }
    }
}
