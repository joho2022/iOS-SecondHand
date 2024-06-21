//
//  ProductInfoViewController.swift
//  secondhand
//
//  Created by 조호근 on 6/20/24.
//

import UIKit
import SwiftUI
import Combine

class ProductInfoViewController: UIViewController {
    private let titleTextField: UITextField = {
        let titleField = UITextField()
        titleField.font = .systemFont(ofSize: 20, weight: .regular)
        titleField.backgroundColor = .gray
        titleField.placeholder = "글제목"
        titleField.translatesAutoresizingMaskIntoConstraints = false
        return titleField
    }()
    
    private var categoryScrollView: UIScrollView?
    private var categoryStackView: UIStackView?
    private var moreCategoriesButton: UIButton?
    
    private let priceTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.backgroundColor = .systemPink
        textField.placeholder = "₩ 가격(선택사항)"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var cancellables =  Set<AnyCancellable>()
    var viewModel: CategoryViewModel!
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        setupViews()
        setupLayout()
        bindViewModel()
    }
    
    private func setupViews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleTextField)
        mainStackView.addArrangedSubview(priceTextField)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleTextField.heightAnchor.constraint(equalToConstant: 54),
            priceTextField.heightAnchor.constraint(equalToConstant: 54),
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func addCategoryViews() {
        guard categoryScrollView == nil else { return }
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .green
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.backgroundColor = .yellow
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showCategoryTableView), for: .touchUpInside)
        
        scrollView.addSubview(stackView)
        let categoryContainerView = UIView()
        categoryContainerView.translatesAutoresizingMaskIntoConstraints = false
        categoryContainerView.addSubview(scrollView)
        categoryContainerView.addSubview(button)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: categoryContainerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
            scrollView.topAnchor.constraint(equalTo: categoryContainerView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: categoryContainerView.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 50),
            
            button.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: categoryContainerView.trailingAnchor),
            button.widthAnchor.constraint(equalToConstant: 30),
            button.heightAnchor.constraint(equalToConstant: 30),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
        
        categoryContainerView.alpha = 0.0
        
        mainStackView.insertArrangedSubview(categoryContainerView, at: 1)
        
        self.categoryScrollView = scrollView
        self.categoryStackView = stackView
        self.moreCategoriesButton = button
        
        viewModel.generateRandomCategories()
        
        UIView.animate(withDuration: 0.5) {
            categoryContainerView.alpha = 1.0
        }
    }
    
    @objc private func showCategoryTableView() {
        let categoryTableView = CategoryTableViewController()
        categoryTableView.viewModel = self.viewModel
        let navigationController = UINavigationController(rootViewController: categoryTableView)
        navigationController.modalPresentationStyle = .popover
        present(navigationController, animated: true, completion: nil)
    }
    
    private func bindViewModel() {
        viewModel.$randomCategories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                self?.updateCategoryButtons(categories)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] category in
                self?.updateSelectedCategory(category)
            }
            .store(in: &cancellables)
    }
    
    private func updateCategoryButtons(_ categories: [Category]) {
        guard let stackView = categoryStackView else { return }
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for category in categories {
            var config = UIButton.Configuration.plain()
            config.title = category.rawValue
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            
            let action = UIAction { [weak self] sender in
                guard let button = sender.sender as? UIButton,
                      let title = button.configuration?.title,
                      let category = Category(rawValue: title) else {
                    return
                }
                
                self?.viewModel.selectCategory(category)
            }
                    
            let button = UIButton(configuration: config, primaryAction: action)
            
            let buttonHeight: CGFloat = 40
            button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
            button.layer.cornerRadius = buttonHeight / 2
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.customGray600.cgColor
            
            if let selectedCategory = viewModel.selectedCategory, selectedCategory == category {
                button.backgroundColor = .orange
            }
            
            stackView.addArrangedSubview(button)
        }
    }
    
    private func updateSelectedCategory(_ category: Category?) {
        guard let stackView = categoryStackView, let selectedCategory = category else { return }
        
        if !viewModel.randomCategories.contains(selectedCategory) {
            viewModel.randomCategories.insert(selectedCategory, at: 0)
        }
        
        if let index = viewModel.randomCategories.firstIndex(of: selectedCategory) {
            viewModel.randomCategories.remove(at: index)
        }
        viewModel.randomCategories.insert(selectedCategory, at: 0)
        
        updateCategoryButtons(viewModel.randomCategories)
        
        stackView.arrangedSubviews.forEach { button in
            if let button = button as? UIButton {
                if let title = button.configuration?.title, title == selectedCategory.rawValue {
                    button.backgroundColor = .orange
                } else {
                    button.backgroundColor = .clear
                }
            }
        }
        
        categoryScrollView?.setContentOffset(.zero, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension ProductInfoViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleTextField {
            addCategoryViews()
        }
    }
}

// MARK: - Preview
struct ProductInfoViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ProductInfoViewController {
        return ProductInfoViewController(viewModel: CategoryViewModel())
    }
    
    func updateUIViewController(_ uiViewController: ProductInfoViewController, context: Context) {}
}

struct ProductInfoViewController_Previews: PreviewProvider {
    static var previews: some View {
        ProductInfoViewControllerRepresentable()
    }
}
