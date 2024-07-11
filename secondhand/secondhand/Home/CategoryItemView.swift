//
//  CategoryItemView.swift
//  secondhand
//
//  Created by 조호근 on 6/25/24.
//

import SwiftUI

struct CategoryItemView: View {
    let imageName: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 44)
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.customOrange, lineWidth: 2)
                )
            Text(title)
                .font(.system(size: 13, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundColor(.customGray900)
        }
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    CategoryItemView(imageName: "icon_all", title: "테스트", action: {print("test")})
}
