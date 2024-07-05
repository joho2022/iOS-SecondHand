//
//  ChatDetailView.swift
//  secondhand
//
//  Created by 조호근 on 6/27/24.
//

import SwiftUI

struct ChatDetailView: View {
    @EnvironmentObject var chatRoomViewModel: ChatRoomViewModel
    var chatRoom: ChatRoom
    var currentUser: User
    var product: Product
    
    @State private var messageText: String = ""
    
    var body: some View {
        VStack {
            HStack {
                if let imageURL = product.imageURLs.first {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 50, height: 50)
                    }
                }
                VStack(alignment: .leading) {
                    Text(product.title)
                        .font(.headline)
                    Text("\(product.price)원")
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding()
            .overlay(
                VStack {
                    Divider()
                    Spacer()
                    Divider()
                }
            )
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(chatRoom.messages, id: \._id) { message in
                            HStack {
                                if message.sender?._id == currentUser._id {
                                    Spacer()
                                    Text(message.content)
                                        .padding()
                                        .background(Color.orange)
                                        .cornerRadius(8)
                                    .foregroundColor(.white)
                                } else {
                                    Text(message.content)
                                        .padding()
                                        .background(Color.gray)
                                        .cornerRadius(8)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                            }
                            .padding(4)
                            .onAppear {
                                if message.sender?._id != currentUser._id && !message.isRead {
                                    chatRoomViewModel.markMessageAsRead(message)
                                }
                            }
                        }
                    }
                    .onAppear {
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: chatRoom.messages.count) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                } // ScrollView
            }
            
            HStack {
                TextField("메시지 입력", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 30)
                
                Button(action: sendMessage) {
                    Text("전송")
                        .padding()
                        .background(messageText.isEmpty ? Color.gray : Color.orange)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
        }
        .navigationBarTitle(chatRoom.participants.first(where: { $0._id != currentUser._id })?.username ?? "채팅", displayMode: .inline)
    }
    
    private func sendMessage() {
        chatRoomViewModel.sendMessage(messageText, in: chatRoom, from: currentUser)
        messageText = ""
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessageId = chatRoom.messages.last?._id {
            withAnimation {
                proxy.scrollTo(lastMessageId, anchor: .bottom)
            }
        }
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUser1 = User(value: ["_id": UUID().uuidString, "username": "Alice", "profileImageData": UIImage(systemName: "person.circle.fill")?.pngData() ?? Data()])
        let sampleUser2 = User(value: ["_id": UUID().uuidString, "username": "Bob", "profileImageData": UIImage(systemName: "person.circle.fill")?.pngData() ?? Data()])
        
        let sampleMessage1 = Message(value: ["_id": UUID().uuidString, "sender": sampleUser1, "content": "Hello, Bob!", "timestamp": Date(), "isRead": false])
        let sampleMessage2 = Message(value: ["_id": UUID().uuidString, "sender": sampleUser2, "content": "Hi, Alice!Hi, Alice!Hi, Alice!Hi, Alice!Hi, Alice!Alice!", "timestamp": Date(), "isRead": false])
        
        let sampleChatRoom = ChatRoom(value: ["_id": UUID().uuidString, "participants": [sampleUser1, sampleUser2], "messages": [sampleMessage1, sampleMessage2], "updatedAt": Date(), "productId": 1])
        
        let sampleProduct = Product(id: 0, title: "나이키 티셔츠", price: 40000, location: "역삼동", category: [.mensFashion, .popular], images: ["https://kream-phinf.pstatic.net/MjAyMzA0MTRfMjAw/MDAxNjgxNDUxNDAyMTUz.5q0cKoTNu0T3fLSHXHRomwuYI5EE3bxDXCcjHFeZnuUg.ts4o7ZUeK19uolxTSWNmVNDCr_mg9472IQ0YZcj0heIg.JPEG/a_d7263afeb4e04111abafbda2b5b67bea.jpg?type=l_webp"], timePosted: "2024-06-10T13:14:08", likes: 10, comments: 2, status: .selling, user: "테스트", description: "테스트 설명입니다")
        
        return ChatDetailView(chatRoom: sampleChatRoom, currentUser: sampleUser1, product: sampleProduct)
    }
}
