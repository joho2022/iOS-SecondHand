//
//  ProductRow.swift
//  secondhand
//
//  Created by 조호근 on 6/11/24.
//

import SwiftUI
import os

struct ProductRow: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Group {
                AsyncImage(url: URL(string: product.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
            } // Group
            .frame(width: 120, height: 120)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.customGray600, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            )
            
            VStack(alignment: .leading, spacing: 4.0) {
                Text(product.title)
                    .font(.system(size: 15, weight: .regular))
                
                if let postedDate = Date.dateFromString(product.timePosted) {
                    Text(product.location + " · " + postedDate.timeAgoDisplay())
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.customGray800)
                } else {
                    Text(product.location)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.customGray800)
                }
                
                HStack {
                    if product.isReserved {
                        Text("예약중")
                            .foregroundColor(.customWhite)
                            .font(.system(size: 12, weight: .regular))
                            .frame(width: 50, height: 22)
                            .background(.customMint)
                            .cornerRadius(5)
                    }
                    
                    Text("\(product.price)원")
                        .font(.system(size: 17, weight: .semibold))
                } // HStack
                
                HStack {
                    if product.comments > 0 {
                        HStack(alignment: .center, spacing: 5) {
                            Image(systemName: "message")
                            Text("\(product.comments)")
                        }
                    }
                    if product.likes > 0 {
                        HStack(alignment: .center, spacing: 5) {
                            Image(systemName: "heart")
                            Text("\(product.likes)")
                        }
                    }
                } // HStack
                .frame(height: 20)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 24)
            } // VStack
            .padding(.top, 3)  
        } // HStack
        .frame(height: 150)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    struct PreviewWrapper: View {
        let sampleProduct = Product(id: 0, title: "나이키 티셔츠", price: 40000, location: "역삼동", category: [.mensFashion, .popular], image: "https://kream-phinf.pstatic.net/MjAyMzA0MTRfMjAw/MDAxNjgxNDUxNDAyMTUz.5q0cKoTNu0T3fLSHXHRomwuYI5EE3bxDXCcjHFeZnuUg.ts4o7ZUeK19uolxTSWNmVNDCr_mg9472IQ0YZcj0heIg.JPEG/a_d7263afeb4e04111abafbda2b5b67bea.jpg?type=l_webp", timePosted: "2024-06-10T13:14:08", likes: 10, comments: 2, isReserved: true)
        
        var body: some View {
            ProductRow(product: sampleProduct)
        }
    }
    return PreviewWrapper()
}
