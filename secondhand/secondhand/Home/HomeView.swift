//
//  HomeView.swift
//  secondhand
//
//  Created by 조호근 on 6/10/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var showAlert: Bool = false
    @State private var showLocationSettingView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                ProductListView(viewModel: ProductListViewModel(userManager: userManager))
                    .navigationBarItems(
                        leading: menuContent)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("로그인 필요"),
                message: Text("동네 설정은 로그인 후 이용 가능한 서비스입니다.")
                , dismissButton: .default(Text("확인"))
            )
        }
        .sheet(isPresented: $showLocationSettingView) {
            LocationSettingView(userManager: userManager)
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
}

#Preview {
    HomeView()
        .environmentObject(UserManager())
}
