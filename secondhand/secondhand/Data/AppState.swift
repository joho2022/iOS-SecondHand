//
//  AppState.swift
//  secondhand
//
//  Created by 조호근 on 6/26/24.
//

import Foundation
import RealmSwift
import os

class AppState: ObservableObject {
    @Published var realm: Realm?
    private var app: App
    
    init() {
        self.app = App(id: "application-0-fahelom")
        login()
    }
    
    private func login() {
        let credentials = Credentials.anonymous
        app.login(credentials: credentials) { [weak self] result in
            switch result {
            case .failure(let error):
                os_log(.error, "Failed to log in: %{public}@", "\(error.localizedDescription)")
            case .success(_):
                self?.configureRealm()
            }
        }
    }
    
    private func configureRealm() {
        guard let user = app.currentUser else {
            os_log(.error, "No current user")
            return
        }
        
        var configuration = user.flexibleSyncConfiguration()
        configuration.objectTypes = [User.self, Location.self, ChatRoom.self, Message.self]
        
        Realm.asyncOpen(configuration: configuration) { [weak self] result in
            switch result {
            case .failure(let error):
                os_log(.error, "Failed to open Realm: %{public}@", "\(error.localizedDescription)")
            case .success(let realm):
                self?.setupSubscriptions(in: realm)
            }
        }
    }
    
    private func setupSubscriptions(in realm: Realm) {
        let subscriptions = realm.subscriptions
        subscriptions.update {
            if subscriptions.first(named: "allLocations") == nil {
                subscriptions.append(QuerySubscription<Location>(name: "allLocations"))
            }
            if subscriptions.first(named: "allUsers") == nil {
                subscriptions.append(QuerySubscription<User>(name: "allUsers"))
            }
            if subscriptions.first(named: "allChatRooms") == nil {
                subscriptions.append(QuerySubscription<ChatRoom>(name: "allChatRooms"))
            }
            if subscriptions.first(named: "allMessages") == nil {
                subscriptions.append(QuerySubscription<Message>(name: "allMessages"))
            }
        } onComplete: { error in
            if let error = error {
                print("Failed to update subscriptions: \(error.localizedDescription)")
            } else {
                print("Successfully updated subscriptions")
                DispatchQueue.main.async {
                    self.realm = realm
                }
            }
        }
    }
}
