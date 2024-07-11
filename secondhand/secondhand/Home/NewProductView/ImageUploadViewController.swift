//
//  ImageUploadViewController.swift
//  secondhand
//
//  Created by 조호근 on 6/20/24.
//

import UIKit
import SwiftUI
import PhotosUI

class ImageUploadViewController: UIViewController {
    
    @Published private(set) var selectedImages: [UIImage] = []
    
    private lazy var imageButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        
        let image = UIImage(systemName: "camera")
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        configuration.image = image?.applyingSymbolConfiguration(imageConfiguration)
        
        var attributedTitle = AttributedString("0/10")
        attributedTitle.font = .systemFont(ofSize: 14, weight: .regular)
        configuration.attributedTitle = attributedTitle
        
        configuration.imagePlacement = .top
        configuration.imagePadding = 8
        configuration.baseForegroundColor = .black
        configuration.background.strokeColor = .customGray600
        configuration.background.strokeWidth = 1.0
        configuration.background.cornerRadius = 10
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let imagesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let imagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(imagesScrollView)
        imagesScrollView.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(imageButton)
        containerStackView.addArrangedSubview(imagesStackView)
        
        NSLayoutConstraint.activate([
            imagesScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            imagesScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagesScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagesScrollView.heightAnchor.constraint(equalToConstant: 120),
            
            imageButton.widthAnchor.constraint(equalToConstant: 88),
            imageButton.heightAnchor.constraint(equalToConstant: 88),
            
            containerStackView.centerYAnchor.constraint(equalTo: imagesScrollView.centerYAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: imagesScrollView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: imagesScrollView.trailingAnchor, constant: -16),
            containerStackView.heightAnchor.constraint(equalToConstant: 88)
        ])
    }
    
    @objc private func imageButtonTapped() {
        guard selectedImages.count < 10 else { return }
        
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 10 - selectedImages.count
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func updateImageCountLabel() {
        var configuration = imageButton.configuration
        var attributedTitle = AttributedString("\(selectedImages.count)/10")
        attributedTitle.font = .systemFont(ofSize: 14, weight: .regular)
        configuration?.attributedTitle = attributedTitle
        imageButton.configuration = configuration
    }
    
    private func updateImagesScrollView() {
        imagesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, image) in selectedImages.enumerated() {
            let imageView = createImageView(with: image)
            let xmarkView = createXmarkView()
            
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(imageView)
            containerView.addSubview(xmarkView)
            
            if index == 0 {
                let label = createLabel()
                imageView.addSubview(label)
                
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                    label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    label.heightAnchor.constraint(equalToConstant: 30)
                ])
            }
            
            imagesStackView.addArrangedSubview(containerView)
            
            let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(deleteImage(_:)))
            let tapGestureXmark = UITapGestureRecognizer(target: self, action: #selector(deleteImage(_:)))
            
            imageView.addGestureRecognizer(tapGestureImage)
            xmarkView.addGestureRecognizer(tapGestureXmark)
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 88),
                imageView.heightAnchor.constraint(equalToConstant: 88),
                
                xmarkView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -8),
                xmarkView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8),
                xmarkView.widthAnchor.constraint(equalToConstant: 30),
                xmarkView.heightAnchor.constraint(equalToConstant: 30),
                
                containerView.widthAnchor.constraint(equalToConstant: 88),
                containerView.heightAnchor.constraint(equalToConstant: 88)
            ])
        }
    }
    
    private func createImageView(with image: UIImage) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.customGray600.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }
    
    private func createXmarkView() -> UIImageView {
        guard var xmarkImage = UIImage(systemName: "xmark.circle.fill") else { return UIImageView() }
        let primaryColor = UIColor.white
        let secondaryColor = UIColor.black
        
        let configuration = UIImage.SymbolConfiguration(paletteColors: [primaryColor, secondaryColor])
        xmarkImage = xmarkImage.withConfiguration(configuration)
        
        let xmarkView = UIImageView(image: xmarkImage)
        xmarkView.translatesAutoresizingMaskIntoConstraints = false
        xmarkView.isUserInteractionEnabled = true
        return xmarkView
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.text = "대표 사진"
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    @objc private func deleteImage(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        
        if let containerView = tappedView.superview,
           let index = imagesStackView.arrangedSubviews.firstIndex(of: containerView) {
            
            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                containerView.alpha = 0
                containerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }
            
            animator.addCompletion { position in
                switch position {
                case .end:
                    self.selectedImages.remove(at: index)
                    self.updateImagesScrollView()
                    self.updateImageCountLabel()
                case .start:
                    break
                case .current:
                    break
                @unknown default:
                    break
                }
            }
            
            animator.startAnimation()
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ImageUploadViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { (object, _) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.selectedImages.append(image)
                        self.updateImageCountLabel()
                        self.updateImagesScrollView()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct ImageUploadViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ImageUploadViewController {
        return ImageUploadViewController()
    }
    
    func updateUIViewController(_ uiViewController: ImageUploadViewController, context: Context) {}
}

struct ImageUploadViewController_Previews: PreviewProvider {
    static var previews: some View {
        ImageUploadViewControllerRepresentable()
    }
}
