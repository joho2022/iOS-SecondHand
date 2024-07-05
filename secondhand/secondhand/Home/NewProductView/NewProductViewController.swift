//
//  NewProductViewController.swift
//  secondhand
//
//  Created by 조호근 on 6/22/24.
//

import UIKit
import SwiftUI
import Combine
import os

class NewProductViewController: UIViewController {
    private let userManager: UserManager
    private let productManager: ProductManager
    private let imageManager: ImageSavingProtocol
    private let imageUploadViewController = ImageUploadViewController()
    private let productInfoViewController: ProductInfoViewController
    private let toolBar = UIToolbar()
    private let locationButton = UIButton(type: .system)
    private let selectedLocationLabel = UILabel()
    
    private var cancellables = Set<AnyCancellable>()
    
    var onDone: (() -> Void)?
    var onClose: (() -> Void)?
    
    init(userManager: UserManager, productManager: ProductManager, imageManager: ImageSavingProtocol) {
        self.userManager = userManager
        self.productManager = productManager
        self.imageManager = imageManager
        
        let defaultLocation = userManager.getDefaultLocation().dongName
        let placeholderText = "(\(defaultLocation))에 올릴 게시물 내용을 작성해주세요.(판매금지 물품은 게시가 제한 될 수 있어요.)"
        self.productInfoViewController = ProductInfoViewController(viewModel: CategoryViewModel(), placeholderText: placeholderText)
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.userManager = UserManager(realmManager: RealmManager(realm: nil))
        self.productManager = ProductManager()
        self.imageManager = ImageManager()
        
        let defaultLocation = userManager.getDefaultLocation().dongName
        let placeholderText = "(\(defaultLocation))에 올릴 게시물 내용을 작성해주세요.(판매금지 물품은 게시가 제한 될 수 있어요.)"
        self.productInfoViewController = ProductInfoViewController(viewModel: CategoryViewModel(), placeholderText: placeholderText)
        super.init(coder: coder)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupToolBar()
        bindViewModel()
    }
    
    private func setup() {
        addChild(imageUploadViewController)
        addChild(productInfoViewController)
        
        view.addSubview(imageUploadViewController.view)
        view.addSubview(productInfoViewController.view)
        
        imageUploadViewController.didMove(toParent: self)
        productInfoViewController.didMove(toParent: self)
        
        imageUploadViewController.view.translatesAutoresizingMaskIntoConstraints = false
        productInfoViewController.view.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            imageUploadViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageUploadViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageUploadViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageUploadViewController.view.heightAnchor.constraint(equalToConstant: 150),
            
            productInfoViewController.view.topAnchor.constraint(equalTo: imageUploadViewController.view.bottomAnchor),
            productInfoViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productInfoViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productInfoViewController.view.bottomAnchor.constraint(equalTo: toolBar.topAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "내 물건 팔기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
  
    @objc func closeButtonTapped() {
        onClose?()
    }
    
    private func bindViewModel() {
        imageUploadViewController.$selectedImages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedImages in
                print("Selected Images: \(selectedImages.count)")
                self?.updateDoneButtonState() }
            .store(in: &cancellables)
        
        productInfoViewController.$isValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                print("Is Valid: \(isValid)")
                self?.updateDoneButtonState() }
            .store(in: &cancellables)
    }
    
    private func updateDoneButtonState() {
        let isImageSelected = !imageUploadViewController.selectedImages.isEmpty
        let isInfoValid = productInfoViewController.isValid
        print("[ Update 완료 버튼 상태 ]: - isImageSelected: \(isImageSelected), isInfoValid: \(isInfoValid)")
        navigationItem.rightBarButtonItem?.isEnabled = isImageSelected && isInfoValid
    }
    
    @objc func doneButtonTapped() {
        guard let title = productInfoViewController.titleText, !title.isEmpty,
              let selectedCategory = productInfoViewController.viewModel.selectedCategory,
              let description = productInfoViewController.descriptionText, !description.isEmpty,
              !imageUploadViewController.selectedImages.isEmpty,
              let username = userManager.user?.username else {
            return
        }
        
        let selectedImages = imageUploadViewController.selectedImages
        var imagePaths: [String] = []
        
        for image in selectedImages {
            let fileName = UUID().uuidString + ".jpg"
            if let imagePath = imageManager.saveImageToDocumentsDirectory(image: image, fileName: fileName) {
                imagePaths.append(imagePath)
            } else {
                os_log(.error, "Error doneButtonTapped(): \(fileName)")
                return
            }
        }
        
        let newProduct = Product(
            id: productManager.getNextProductId(),
            title: title,
            price: Int(productInfoViewController.priceText ?? "0") ?? 0,
            location: selectedLocationLabel.text ?? userManager.getDefaultLocation().dongName,
            category: [selectedCategory],
            images: imagePaths,
            timePosted: Date().iso8601,
            likes: 0,
            comments: 0,
            status: .selling,
            user: username,
            description: description
        )
        
        productManager.addProduct(newProduct)
        onDone?()
    }

    private func setupToolBar() {
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
        
        toolBar.setItems([
            UIBarButtonItem(customView: locationButton),
            UIBarButtonItem(customView: selectedLocationLabel),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ], animated: true)
        
        NSLayoutConstraint.activate([
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        locationButton.setImage(UIImage(systemName: "map"), for: .normal)
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        
        selectedLocationLabel.text = userManager.getDefaultLocation().dongName
        
    }
    
    @objc private func locationButtonTapped() {
        let alertController = UIAlertController(title: "동네 선택", message: nil, preferredStyle: .actionSheet)
        
        if let locations = userManager.user?.locations {
            for location in locations {
                let action = UIAlertAction(title: location.dongName, style: .default) { [weak self] _ in
                    self?.userManager.setDefaultLocation(location: location)
                    self?.selectedLocationLabel.text = location.dongName
                }
                alertController.addAction(action)
            }
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Preview
struct NewProductViewControllerRepresentable: UIViewControllerRepresentable {
    var userManager: UserManager
    var productManager: ProductManager
    var imageManager: ImageSavingProtocol
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewController = NewProductViewController(userManager: userManager, productManager: productManager, imageManager: imageManager)
        
        viewController.onDone = {
            isPresented = false
        }
        
        viewController.onClose = {
            isPresented = false
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

struct NewProductViewController_Previews: PreviewProvider {
    static var previews: some View {
        NewProductViewControllerRepresentable(userManager: UserManager(realmManager: RealmManager(realm: nil)), productManager: ProductManager(), imageManager: ImageManager(), isPresented: .constant(true))
    }
}
