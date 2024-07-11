//
//  CategoryTableViewController.swift
//  secondhand
//
//  Created by 조호근 on 6/21/24.
//

import UIKit
import SwiftUI
import Combine

class CategoryTableViewController: UITableViewController {
    
    private let categories = Category.allCases
    var viewModel: CategoryViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CategoryTableCell.self, forCellReuseIdentifier: CategoryTableCell.identifier)
        
        setupNavigationItems()
    }
    
    private func setupNavigationItems() {
        navigationItem.title = "카테고리"
        
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(closeButtonTapped))
        closeButton.tintColor = .black
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableCell.identifier, for: indexPath) as? CategoryTableCell else {
            return UITableViewCell()
        }
        let category = categories[indexPath.row]
        cell.configure(with: category)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        viewModel.selectCategory(category)
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

// MARK: - Preview
struct CategoryTableViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> CategoryTableViewController {
        return CategoryTableViewController()
    }
    
    func updateUIViewController(_ uiViewController: CategoryTableViewController, context: Context) {}
}

struct CategoryTableViewController_Previews: PreviewProvider {
    static var previews: some View {
        CategoryTableViewControllerRepresentable()
    }
}
