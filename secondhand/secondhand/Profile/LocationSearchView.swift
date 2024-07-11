//
//  LocationSearchView.swift
//  secondhand
//
//  Created by 조호근 on 6/5/24.
//

import SwiftUI

struct LocationSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = LocationSearchViewModel(addressService: AddressService())
    @Binding var selectedLocation: Address?
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.customGray800)
                            .padding(.leading, 8)
                        TextField("동명(읍, 면)으로 검색(ex. 서초동)", text: $viewModel.searchQuery)
                            .padding(10)
                            .foregroundColor(.customGray800)
                    }
                    .background(.customGray400)
                    .cornerRadius(8)
                    .padding()
                    
                    Divider()
                        
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.searchResults, id: \.self) { result in
                                Text(result.roadAddr)
                                    .padding()
                                    .onTapGesture {
                                        selectedLocation = result
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                    .onAppear {
                                        if result == viewModel.searchResults.last {
                                            viewModel.loadMoreResult()
                                        }
                                    }
                                Divider()
                            }
                        }
                    }
 
                    Spacer()
                    
                } // VStack
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }// ZStack
            .navigationBarTitle("주소 검색", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("닫기")
                    .foregroundColor(.customBlack)
            })
        } // NavigationView
    } // View
}

#Preview {
    struct PreviewWrapper: View {
        @State var value: Address? = Address(roadAddr: "", emdNm: "")
        
        var body: some View {
            LocationSearchView(selectedLocation: $value)
        }
    }
    return PreviewWrapper()
}
