//
//  SignUpView.swift
//  secondhand
//
//  Created by 조호근 on 6/4/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = SignUpViewModel()
    @State private var inputImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                if !viewModel.showSuccessView {
                    Divider()
                    
                    Button {
                        viewModel.showImagePicker = true
                    } label: {
                        ZStack {
                            Circle()
                                .stroke(.customGray500, lineWidth: 3)
                                .frame(width: 80, height: 80)
                            if let image = viewModel.profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                Image(systemName: "camera")
                                    .resizable()
                                    .frame(width: 35, height: 29)
                                    .foregroundColor(.customWhite)
                            } else {
                                Image(systemName: "camera")
                                    .resizable()
                                    .frame(width: 35, height: 29)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .padding(.top, 90)
                    .sheet(isPresented: $viewModel.showImagePicker, content: {
                        ImagePicker(image: $inputImage)
                    })
                    .onChange(of: inputImage) { _ in
                        viewModel.loadImage(inputImage: inputImage)
                    }
                    
                    HStack(spacing: 30) {
                        Text("아이디")
                        TextField("아이디를 입력하세요", text: $viewModel.username)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)
                    
                    Divider()
                    
                    Button {
                        viewModel.showLocationSearch = true
                    } label: {
                        HStack {
                            if viewModel.locationName.isEmpty {
                                Image(systemName: "plus")
                                Text("위치 추가")
                                    .font(.system(.regular, size: 15))
                            } else {
                                Text(viewModel.locationName)
                                    .foregroundColor(.customWhite)
                                    .font(.system(.regular, size: 15))
                                Spacer()
                                Image(systemName: "xmark")
                                    .foregroundColor(.customWhite)
                            }
                        }
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.customGray500, lineWidth: 1.5)
                        )
                        .background(viewModel.locationName.isEmpty ? Color.clear : .customOrange)
                    }
                    .padding(.top, 40)
                    .padding()
                    .sheet(isPresented: $viewModel.showLocationSearch, content: {
                        LocationSearchView(selectedLocation: $viewModel.locationName)
                    })
                    
                    Spacer()
                } else {
                    SignUpSuccessView()
                }
                
            } // VStack
            .navigationBarTitle("회원가입", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button {
                        print("닫기")
                    } label: {
                        Text("닫기")
                            .foregroundColor(.customBlack)
                    },
                trailing:
                    Button {
                        if viewModel.showSuccessView {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            viewModel.signUp()
                        }
                    } label: {
                        Text("완료")
                            .font(.system(.semibold, size: 17))
                    }
                    .disabled(viewModel.username.isEmpty || viewModel.locationName.isEmpty)
                    .alert(isPresented: $viewModel.showErrorAlert, content: {
                        Alert(title: Text("오류"), message: Text("서버저장에 실패하였습니다."), dismissButton: .default(Text("확인")))
                    })
            )
        } // NavigationView
    }
}

// MARK: - 프로필 사진 선택
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}

// MARK: - 회원가입 성공시 화면
private struct SignUpSuccessView: View {
    var body: some View {
        VStack {
            Text("축하합니다!")
                .font(.system(.regular, size: 28))
                .padding(.top, 40)
            
            Text("회원가입을 완료했습니다.")
                .font(.system(.regular, size: 17))
                .padding(.top, 32)
            Text("지금 로그인해보세요!")
                .font(.system(.regular, size: 17))
            
            Spacer()
        }
    }
}

#Preview {
    SignUpView()
}