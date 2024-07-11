//
//  ChatListView.swift
//  secondhand
//
//  Created by 조호근 on 6/27/24.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var chatRoomViewModel: ChatRoomViewModel
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var productManager: ProductManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(chatRoomViewModel.chatRooms, id: \.id) { chatRoom in
                        if let currentUser = userManager.user, let product = productManager.getProduct(byId: chatRoom.productId) {
                            NavigationLink(destination: ChatDetailView(chatRoom: chatRoom, currentUser: currentUser, product: product)) {
                                ChatRoomRow(chatRoom: chatRoom, currentUser: currentUser, product: product)
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                            }
                            Divider()
                        }
                    }
                }
                .padding(.top)
            }
            .navigationBarTitle("채팅", displayMode: .inline)
        }
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUser1 = User(value: ["_id": UUID().uuidString, "username": "Alice", "profileImageData": UIImage(systemName: "person.circle.fill")?.pngData() ?? Data()])
        let sampleUser2 = User(value: ["_id": UUID().uuidString, "username": "Bob", "profileImageData": UIImage(systemName: "person.circle.fill")?.pngData() ?? Data()])
        
        let sampleMessage1 = Message(value: ["_id": UUID().uuidString, "sender": sampleUser1, "content": "Hello, Bob!", "timestamp": Date(), "isRead": false])
        let sampleMessage2 = Message(value: ["_id": UUID().uuidString, "sender": sampleUser2, "content": "Hi, Alice!", "timestamp": Date(), "isRead": false])
        
        let sampleChatRoom = ChatRoom(value: ["_id": UUID().uuidString, "participants": [sampleUser1, sampleUser2], "messages": [sampleMessage1, sampleMessage2], "updatedAt": Date(), "productId": 1])
        
        let sampleProduct = Product(id: 1, title: "Sample Product", price: 100, location: "Sample Location", category: [], image: "https://kream-phinf.pstatic.net/MjAyMzA0MTRfMjAw/MDAxNjgxNDUxNDAyMTUz.5q0cKoTNu0T3fLSHXHRomwuYI5EE3bxDXCcjHFeZnuUg.ts4o7ZUeK19uolxTSWNmVNDCr_mg9472IQ0YZcj0heIg.JPEG/a_d7263afeb4e04111abafbda2b5b67bea.jpg?type=l_webp", timePosted: "Just now", likes: 10, comments: 5, isReserved: false, user: "Alice", description: "This is a sample product.")
        
        let chatRoomViewModel = ChatRoomViewModel(realm: nil)
        chatRoomViewModel.chatRooms = [sampleChatRoom]
        
        let userManager = UserManager(realmManager: RealmManager(realm: nil))
        userManager.user = sampleUser1
        
        let productManager = ProductManager()
        
        return ChatListView()
            .environmentObject(chatRoomViewModel)
            .environmentObject(userManager)
            .environmentObject(productManager)
    }
}
