//
//  Chat.swift
//  secondhand
//
//  Created by 조호근 on 6/26/24.
//

import Foundation
import RealmSwift

class ChatRoom: Object {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted var participants = List<User>()
    @Persisted var messages = List<Message>()
    @Persisted var updatedAt: Date = Date()
}

class Message: Object {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted var sender: User?
    @Persisted var content: String = ""
    @Persisted var timestamp: Date = Date()
    @Persisted var isRead: Bool = false
}
