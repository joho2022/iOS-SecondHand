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
    @Published var isValid = false
    private let placeholderText: String
    
    private let titleTextField: UITextField = {
        let titleField = UITextField()
        titleField.font = .systemFont(ofSize: 20, weight: .regular)
        titleField.placeholder = "글제목"
        titleField.translatesAutoresizingMaskIntoConstraints = false
        return titleField
    }()
    
    var titleText: String? {
        return titleTextField.text
    }
    
    private var categoryScrollView: UIScrollView?
    private var categoryStackView: UIStackView?
    private var moreCategoriesButton: UIButton?
    
    private let priceTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 20, weight: .regular)
        textField.placeholder = "₩ 가격(선택사항)"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var priceText: String? {
        return priceTextField.text
    }
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20, weight: .regular)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var descriptionText: String? {
        return descriptionTextView.text
    }
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var cancellables =  Set<AnyCancellable>()
    var viewModel: CategoryViewModel!
    
    init(viewModel: CategoryViewModel, placeholderText: String) {
        self.viewModel = viewModel
        self.placeholderText = placeholderText
        super.init(nibName: nil, bundle: nil)
        bindValidation()
    }
    
    required init?(coder: NSCoder) {
        self.placeholderText = ""
        self.viewModel = CategoryViewModel()
        super.init(coder: coder)
        bindValidation()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        setupViews()
        setupLayout()
        bindViewModel()
        setPlaceholder()
    }
    
    private func setupViews() {
        view.addSubview(mainStackView)
        addSeparator(to: mainStackView)
        mainStackView.addArrangedSubview(titleTextField)
        addSeparator(to: mainStackView)
        mainStackView.addArrangedSubview(priceTextField)
        addSeparator(to: mainStackView)
        mainStackView.addArrangedSubview(descriptionTextView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleTextField.heightAnchor.constraint(equalToConstant: 54),
            priceTextField.heightAnchor.constraint(equalToConstant: 54),
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        descriptionTextView.heightAnchor.constraint(equalToConstant: descriptionTextView.font!.lineHeight * 5 + descriptionTextView.textContainerInset.top + descriptionTextView.textContainerInset.bottom).isActive = true
    }
    
    private func setPlaceholder() {
        descriptionTextView.text = placeholderText
        descriptionTextView.textColor = .lightGray
    }
    
    private func addCategoryViews() {
        guard categoryScrollView == nil else { return }
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton(type: .system)
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
        
        mainStackView.insertArrangedSubview(categoryContainerView, at: 2)
        
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
    
    private func bindValidation() {
        titleTextField.publisher(for: \.text)
            .sink { [weak self] _ in self?.validateFields() }
            .store(in: &cancellables)
        
        descriptionTextView.publisher(for: \.text)
            .sink { [weak self] _ in self?.validateFields() }
            .store(in: &cancellables)
        
        viewModel.$selectedCategory
            .sink { [weak self] _ in self?.validateFields() }
            .store(in: &cancellables)
    }
    
    private func validateFields() {
        let title = titleTextField.text ?? ""
        let description = descriptionTextView.text ?? ""
        let isDescriptionPlaceholder = description == placeholderText
        
        isValid = !title.isEmpty && viewModel.selectedCategory != nil && !description.isEmpty && !isDescriptionPlaceholder
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
                button.configuration?.baseForegroundColor = .white
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
                    button.configuration?.baseForegroundColor = .white
                } else {
                    button.backgroundColor = .clear
                }
            }
        }
        
        categoryScrollView?.setContentOffset(.zero, animated: true)
    }
    
    private func addSeparator(to stackView: UIStackView) {
        let separator = UIView()
        separator.backgroundColor = .customGray600
        separator.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(separator)
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension ProductInfoViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleTextField {
            addCategoryViews()
        }
        validateFields()
    }
}

// MARK: - UITextViewDelegate
extension ProductInfoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        let lineHeight = textView.font!.lineHeight
        let maxLines = 15
        let numberOfLines = Int(estimatedSize.height / lineHeight)
        let roundedLines = min(ceil(Double(numberOfLines) / 5) * 5, Double(maxLines))
        let newHeight = lineHeight * CGFloat(roundedLines) + textView.textContainerInset.top + textView.textContainerInset.bottom
        
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = newHeight
            }
        }
        validateFields()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        }
        validateFields()
    }
}

// MARK: - Preview
struct ProductInfoViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ProductInfoViewController {
        return ProductInfoViewController(viewModel: CategoryViewModel(), placeholderText: "테스트 placeholder")
    }
    
    func updateUIViewController(_ uiViewController: ProductInfoViewController, context: Context) {}
}

struct ProductInfoViewController_Previews: PreviewProvider {
    static var previews: some View {
        ProductInfoViewControllerRepresentable()
    }
}
