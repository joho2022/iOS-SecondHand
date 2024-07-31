//
//  ProductDetailView.swift
//  SecondHand
//
//  Created by 조호근 on 7/6/24.
//

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ProductDetailViewModel
    @Binding var isPresentingDetailView: Bool
    @State private var isDragging = false
    @State private var showConfirmationDialog = false
    
    init(viewModel: ProductDetailViewModel, isPresentingDetailView: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isPresentingDetailView = isPresentingDetailView
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer()
            }
            .background(Color.white)
            
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        TabView {
                            ForEach(viewModel.product.imageURLs, id: \.self) { url in
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        ProgressView()
                                        
                                    }
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("판매자 정보")
                                    .font(.system(size: 15, weight: .regular))
                                Spacer()
                                Text(viewModel.product.user)
                                    .font(.system(size: 15, weight: .regular))
                            }
                            .padding()
                            .background(Color.customGray50)
                            .cornerRadius(15)
                            
                            Menu {
                                Button {
                                    viewModel.updateProductStatus(to: .selling)
                                } label: {
                                    Text("판매중")
                                }
                                Button {
                                    viewModel.updateProductStatus(to: .reserved)
                                } label: {
                                    Text("예약중")
                                }
                                Button {
                                    viewModel.updateProductStatus(to: .soldOut)
                                } label: {
                                    Text("판매완료")
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.product.status.rawValue)
                                        .font(.system(size: 12, weight: .regular))
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                }
                                .padding()
                                .frame(width: 106, height: 32)
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.customGray400, lineWidth: 1)
                                )
                            }
                            
                            VStack(spacing: 8) {
                                Text(viewModel.product.title)
                                    .font(.system(size: 17, weight: .semibold))
                                
                                if let postedDate = Date.dateFromString(viewModel.product.timePosted) {
                                    Text("\(viewModel.product.category[0].rawValue) ・ \(postedDate.timeAgoDisplay())")
                                        .foregroundColor(.customGray800)
                                        .font(.system(size: 13, weight: .regular))
                                }
                            } // VStack
                            
                            Text(viewModel.product.description)
                                .foregroundColor(.customGray900)
                                .font(.system(size: 17, weight: .regular))
                            
                            HStack {
                                Text("채팅 \(viewModel.product.comments)")
                                Text("관심 \(viewModel.product.likes)")
                                Text("조회 \(viewModel.product.views)")
                            }
                            .foregroundColor(.customGray900)
                            .font(.system(size: 13, weight: .regular))
                            
                        }
                        .padding()
                    }
                    .background(GeometryReader { geo -> Color in
                        DispatchQueue.main.async {
                            let newIsDragging = geo.frame(in: .global).minY < -100
                            if newIsDragging != isDragging {
                                isDragging = newIsDragging
                            }
                        }
                        return Color.clear
                    })
                } // ScrollView
            } // ScrollViewReader
            .edgesIgnoringSafeArea(.top)
            
            HStack {
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? .red : .black)
                }
                
                Text("\(viewModel.product.price)원")
                    .font(.system(size: 13, weight: .regular))
                
                Spacer()
                
                Button {
                    // viewModel.startChat()
                } label: {
                    Text("대화 중인 채팅방")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 120, height: 32)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.white)
        } // VStack
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button {
                    isPresentingDetailView = false
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                },
            trailing:
                Button {
                    showConfirmationDialog = true
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                }
                .confirmationDialog(
                    "게시글 관리",
                    isPresented: $showConfirmationDialog,
                    titleVisibility: .hidden
                ) {
                    Button("게시글 수정") {
                        viewModel.modifyProduct()
                    }
                    Button("삭제", role: .destructive) {
                        viewModel.showDeleteAlert = true
                    }
                    Button("취소", role: .cancel) { }
                }
                .alert(isPresented: $viewModel.showDeleteAlert) {
                    Alert(
                        title: Text("삭제 확인"),
                        message: Text("정말로 삭제하시겠습니까?"),
                        primaryButton: .destructive(Text("삭제")) {
                            viewModel.deleteProduct()
                        },
                        secondaryButton: .cancel()
                    )
                }
        )
    } // Body
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let product = Product(
            id: 1,
            title: "나이키 티셔츠",
            price: 40000,
            location: "역삼동",
            category: [.popular],
            images: ["https://kream-phinf.pstatic.net/MjAyMzA0MTRfMjAw/MDAxNjgxNDUxNDAyMTUz.5q0cKoTNu0T3fLSHXHRomwuYI5EE3bxDXCcjHFeZnuUg.ts4o7ZUeK19uolxTSWNmVNDCr_mg9472IQ0YZcj0heIg.JPEG/a_d7263afeb4e04111abafbda2b5b67bea.jpg?type=l_webp", "https://kream-phinf.pstatic.net/MjAyNDA1MjRfMzkg/MDAxNzE2NTMyODQzNTgy.ECw3Xikv8w6R1-zs-OcQyVY-SMAN1tSInutYzMkUmNkg.cI4OQfPajMr34SNzLX32WaNQopL02vNol6_yWMQyl8gg.PNG/a_0a36d3746db04595871a75bcc6798e02.png?type=l_webp", "https://kream-phinf.pstatic.net/MjAyMzA0MTRfMjAw/MDAxNjgxNDUxNDAyMTUz.5q0cKoTNu0T3fLSHXHRomwuYI5EE3bxDXCcjHFeZnuUg.ts4o7ZUeK19uolxTSWNmVNDCr_mg9472IQ0YZcj0heIg.JPEG/a_d7263afeb4e04111abafbda2b5b67bea.jpg?type=l_webp"],
            timePosted: "2024-06-10T13:14:08",
            likes: 10,
            comments: 2,
            views: 0,
            status: .selling,
            user: "100",
            description: "편안한 나이키 티셔츠. 운동할 때 입기 좋아요."
        )
        let userManager = UserManager(realmManager: RealmManager(realm: nil))
        let viewModel = ProductDetailViewModel(product: product, isSeller: true, productManager: ProductManager(), userManager: userManager)
        
        ProductDetailView(viewModel: viewModel, isPresentingDetailView: .constant(true))
    }
}
