//
//  secondhandApp.swift
//  secondhand
//
//  Created by 조호근 on 6/3/24.
//

import SwiftUI

@main
struct secondhandApp: App {
    @StateObject private var userManager = UserManager()
    @StateObject private var productManager = ProductManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager)
                .environmentObject(productManager)
        }
    }
}
