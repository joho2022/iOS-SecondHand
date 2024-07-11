//
//  CategoryTableCell.swift
//  secondhand
//
//  Created by 조호근 on 6/21/24.
//

import UIKit
import SwiftUI

class CategoryTableCell: UITableViewCell {

    static let identifier = "CategoryTableCell"
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .customGray900
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        contentView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
    }
    
    func configure(with category: Category) {
        categoryLabel.text = category.rawValue
    }
}
