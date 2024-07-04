//
//  HomeView.swift
//  secondhand
//
//  Created by 조호근 on 6/10/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var productManager: ProductManager
    @State private var showAlert: Bool = false
    @State private var showLocationSettingView: Bool = false
    @State private var selectedCategory: Category?
    @State private var isDragging: Bool = false
    @State private var isPresentingNewProductView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Divider()
                    ProductListView(viewModel: ProductListViewModel(userManager: userManager, productManager: productManager), selectedCategory: $selectedCategory, isDragging: $isDragging)
                        
                }
                .navigationBarTitle(selectedCategory?.rawValue ?? "전체상품", displayMode: .inline)
                .navigationBarItems(
                    leading: menuContent,
                    trailing: categoryButton
                )
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            if userManager.user != nil {
                                isPresentingNewProductView.toggle()
                            } else {
                                showAlert.toggle()
                            }
                        } label: {
                            AddProductButton(isDragging: $isDragging)
                                .padding([.bottom, .trailing], 16)
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("로그인 필요"),
                message: Text("로그인 후 이용 가능한 서비스입니다.")
                , dismissButton: .default(Text("확인"))
            )
        }
        .sheet(isPresented: $showLocationSettingView) {
            LocationSettingView(userManager: userManager)
        }
        .fullScreenCover(isPresented: $isPresentingNewProductView) {
            NewProductViewControllerRepresentable(userManager: userManager, productManager: productManager, imageManager: ImageManager(), isPresented: $isPresentingNewProductView)
        }
    }
    
    private var menuContent: some View {
        Menu {
            if let locations = userManager.user?.locations {
                ForEach(locations, id: \.self) { location in
                    Button(location.dongName) {
                        userManager.setDefaultLocation(location: location)
                    }
                }
            }
            
            Button("내 동네 설정하기") {
                if userManager.user != nil {
                    self.showLocationSettingView.toggle()
                } else {
                    showAlert.toggle()
                }
            }
        } label: {
            HStack {
                if (userManager.user?.locations.first(where: { $0.isDefault })) != nil {
                    Text(userManager.getDefaultLocation().dongName)
                } else {
                    Text("역삼동")
                }
                Image(systemName: "chevron.right")
            }
        }
    }
    
    private var categoryButton: some View {
        NavigationLink(destination: CategoryGridView(selectedCategory: $selectedCategory)) {
            Image(systemName: "line.horizontal.3")
        }
    }
    
    struct AddProductButton: View {
        @Binding var isDragging: Bool
        
        var body: some View {
            HStack {
                Image(systemName: "plus")
                if !isDragging {
                    Text("글쓰기")
                }
            }
            .padding()
            .background(Color.customOrange)
            .foregroundColor(Color.customWhite)
            .cornerRadius(30)
            .animation(.default, value: isDragging)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UserManager(realmManager: RealmManager(realm: nil)))
        .environmentObject(ProductManager())
}
