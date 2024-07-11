//
//  ChatRoomRow.swift
//  secondhand
//
//  Created by 조호근 on 6/27/24.
//

import SwiftUI

struct ChatRoomRow: View {
    var chatRoom: ChatRoom
    var currentUser: User
    var product: Product
    
    var body: some View {
        HStack {
            if let otherUser = chatRoom.participants.first(where: { $0._id != currentUser._id }) {
                let profileImage = otherUser.profileImageData != nil ? UIImage(data: otherUser.profileImageData!) : nil
                Image(uiImage: profileImage ?? UIImage(systemName: "person.circle.fill")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(otherUser.username)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.customBlack)
                        Text(chatRoom.updatedAt.timeAgoDisplay())
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.customGray800)
                        
                        Spacer()
                        
                        let unreadCount = chatRoom.messages.filter { message in
                            !message.isRead && message.sender?._id != currentUser._id
                        }.count
                        if unreadCount > 0 {
                            Text("\(unreadCount)")
                                .font(.caption)
                                .frame(width: 12, height: 12)
                                .padding(5)
                                .background(.customOrange)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                    
                    if let lastMessage = chatRoom.messages.last {
                        Text(lastMessage.content)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.customGray900)
                            .lineLimit(1)
                    }
                } // VStack
                
                Spacer()
                
                if let imageURL = product.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.customGray600, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                            )
                    } placeholder: {
                        ProgressView()
                            .frame(width: 50, height: 50)
                    }
                }
            }
        } // HStack
        .padding(.horizontal, 16)
    }
}

struct ChatRoomRow_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUser1 = User(value: ["_id": UUID().uuidString, "username": "Alice", "profileImageData": UIImage(systemName: "person.circle.fill")?.pngData() ?? Data()])
        let sampleUser2 = User(value: ["_id": UUID().uuidString, "username": "Bob", "profileImageData": UIImage(systemName: "person.circle.fill")?.pngData() ?? Data()])
        
        let sampleMessage1 = Message(value: ["_id": UUID().uuidString, "sender": sampleUser1, "content": "Hello, Bob!", "timestamp": Date(), "isRead": false])
        let sampleMessage2 = Message(value: ["_id": UUID().uuidString, "sender": sampleUser2, "content": "Hi, Alice!Hi, Alice!Hi, Alice!Hi, Alice!Hi, Alice!", "timestamp": Date(), "isRead": false])
        
        let sampleChatRoom = ChatRoom(value: ["_id": UUID().uuidString, "participants": [sampleUser1, sampleUser2], "messages": [sampleMessage1, sampleMessage2], "updatedAt": Date(), "productId": 1])
        
        let sampleProduct = Product(id: 1, title: "Sample Product", price: 100, location: "Sample Location", category: [], image: "https://kream-phinf.pstatic.net/MjAyMzA0MTRfMjAw/MDAxNjgxNDUxNDAyMTUz.5q0cKoTNu0T3fLSHXHRomwuYI5EE3bxDXCcjHFeZnuUg.ts4o7ZUeK19uolxTSWNmVNDCr_mg9472IQ0YZcj0heIg.JPEG/a_d7263afeb4e04111abafbda2b5b67bea.jpg?type=l_webp", timePosted: "Just now", likes: 10, comments: 5, isReserved: false, user: "Alice", description: "This is a sample product.")
        
        return ChatRoomRow(chatRoom: sampleChatRoom, currentUser: sampleUser1, product: sampleProduct)
    }
}
