//
//  LocationSettingView.swift
//  secondhand
//
//  Created by 조호근 on 6/10/24.
//

import SwiftUI
import os

struct LocationSettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: LocationSettingViewModel
    @State private var selectedLocation: Address?
    @State private var showLocationSerachView: Bool = false
    @State private var activeAlert: AlertType?
    
    enum AlertType: Identifiable {
        case deleteLocation
        case minimumLocation
        
        var id: Int {
            self.hashValue
        }
    }
    
    init(userManager: (UserProvider & UserLocationProvider)) {
        _viewModel = StateObject(wrappedValue: LocationSettingViewModel(userManager: userManager))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                VStack {
                    Text("지역은 최소 1개")
                    Text("최대 2개까지 설정 가능해요.")
                }
                .padding(.top, 60)
                
                HStack {
                    ForEach(viewModel.selectedLocations, id: \.self) { location in
                        Button {
                            if viewModel.selectedLocations.count > 1 {
                                selectedLocation = location
                                activeAlert = .deleteLocation
                            } else {
                                activeAlert = .minimumLocation  
                            }
                        } label: {
                            HStack {
                                Text(location.emdNm)
                                    .foregroundColor(.customWhite)
                                    .font(.system(size: 15, weight: .regular))
                                Image(systemName: "xmark")
                                    .foregroundColor(.customWhite)
                                    .padding(.leading, 60)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 52)
                            .background(.customOrange)
                            .cornerRadius(8)
                        }
                    } // ForEach
                    if viewModel.selectedLocations.count < 2 {
                        Button {
                            showLocationSerachView = true
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                    .foregroundColor(.customWhite)
                                    .font(.system(size: 23))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 52)
                            .background(.customGray600)
                            .cornerRadius(8)
                        }
                    }
                } // HStack
                .padding()
                .padding(.top, 60)
                
                Spacer()
            } // VStack
            .navigationBarTitle("동네 설정", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("닫기")
                            .foregroundColor(.customBlack)
                    }
            )
            .sheet(isPresented: $showLocationSerachView) {
                LocationSearchView(selectedLocation: $selectedLocation)
                    .onDisappear {
                        if let selectedLocation = selectedLocation {
                            viewModel.addLocation(selectedLocation)
                        }
                    }
            }
            .alert(item: $activeAlert) { alertType in
                switch alertType {
                case .deleteLocation:
                    return Alert(
                        title: Text("알림"),
                        message: Text("'\(selectedLocation?.emdNm ?? "")'을(를) 삭제하시겠어요?"),
                        primaryButton: .destructive(Text("삭제")) {
                            if let location = selectedLocation {
                                viewModel.removeLocation(location)
                            }
                        },
                        secondaryButton: .cancel(Text("취소"))
                    )
                case .minimumLocation:
                    return Alert(
                        title: Text("알림"),
                        message: Text("동네는 최소 1개 이상 선택하세요."),
                        dismissButton: .default(Text("확인"))
                    )
                }
            }
        } // NavigationView
    }
}

#Preview {
    LocationSettingView(userManager: UserManager())
}
