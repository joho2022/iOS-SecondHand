//
//  ChatRoomViewModel.swift
//  secondhand
//
//  Created by 조호근 on 6/27/24.
//

import Foundation
import RealmSwift
import os

class ChatRoomViewModel: ObservableObject {
    @Published var chatRooms: [ChatRoom] = []
    private var realm: Realm?
    private var notificationToken: NotificationToken?
    
    init(realm: Realm?) {
        self.realm = realm
    }
    
    func fetchChatRooms(for currentUser: User) {
        guard let realm = self.realm else { return }
        let result = realm.objects(ChatRoom.self)
        notificationToken = result.observe { [weak self] changes in
            switch changes {
            case .initial(let chatRooms):
                self?.chatRooms = self?.filterChatRooms(chatRooms, currentUser: currentUser) ?? []
            case .update(let chatRooms, _, _, _):
                self?.chatRooms = self?.filterChatRooms(chatRooms, currentUser: currentUser) ?? []
            case .error(let error):
                os_log(.error, "Error fetching chat rooms:  %{public}@", "\(error.localizedDescription)")
            }
        }
    }
    
    private func filterChatRooms(_ chatRooms: Results<ChatRoom>, currentUser: User) -> [ChatRoom] {
        return chatRooms.filter { chatRoom in
            chatRoom.participants.contains { $0._id == currentUser._id }
        }
    }
    
    func sendMessage(_ messageText: String, in chatRoom: ChatRoom, from sender: User) {
        guard !messageText.isEmpty, let realm = self.realm else { return }
        
        let newMessage = Message()
        newMessage.sender = sender
        newMessage.content = messageText
        newMessage.timestamp = Date()
        newMessage.isRead = false
        
        do {
            try realm.write {
                chatRoom.messages.append(newMessage)
                chatRoom.updatedAt = Date()
            }
        } catch {
            os_log(.error, "Error sending message:  %{public}@", "\(error.localizedDescription)")
        }
    }
    
    func markMessageAsRead(_ message: Message) {
        guard let realm = self.realm else { return }
        
        do {
            try realm.write {
                message.isRead = true
            }
        } catch {
            os_log(.error, "Error marking message as read:  %{public}@", "\(error.localizedDescription)")
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
