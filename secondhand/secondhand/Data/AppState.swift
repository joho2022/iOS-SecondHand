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
    @Published var userManager: UserManager?
    @Published var chatRoomViewModel: ChatRoomViewModel?
    private var app: App
    
    init() {
        self.app = App(id: "application-0-fahelom")
        let realmManager = RealmManager(realm: nil)
        self.userManager = UserManager(realmManager: realmManager)
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
                os_log(.error, "Failed to update subscriptions: %{public}@", "\(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.realm = realm
                    if let userManager = self.userManager {
                        let realmManager = RealmManager(realm: realm)
                        userManager.updateRealmManager(realmManager)
                        self.chatRoomViewModel = ChatRoomViewModel(realm: realm)
                    }
                }
            }
        }
    }
    
    private func insertSampleData() {
        guard let realm = self.realm else { return }
        
        try? realm.write {
            let user1 = realm.object(ofType: User.self, forPrimaryKey: "840C2AEB-E6E8-4BCF-B8D5-AAA88B6F0E0E")
            let user2 = realm.object(ofType: User.self, forPrimaryKey: "A959D814-69D4-4DED-83CD-883E1C0C3F71")
            
            guard let alice = user1, let bob = user2 else {
                print("Error: Users not found")
                return
            }
            
            let message1 = Message()
            message1.sender = alice
            message1.content = "Hello, Bob!"
            message1.timestamp = Date()
            message1.isRead = false
            
            let message2 = Message()
            message2.sender = bob
            message2.content = "Hi, Alice!"
            message2.timestamp = Date()
            message2.isRead = false
            
            let chatRoom = ChatRoom()
            chatRoom.participants.append(objectsIn: [alice, bob])
            chatRoom.messages.append(objectsIn: [message1, message2])
            chatRoom.updatedAt = Date()
            chatRoom.productId = 1
            
            realm.add([message1, message2, chatRoom])
            print("insertSampleData()!!")
        }
    }
}
