//
//  SubCategoryTableViewCell.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 21/01/2021.
//

import UIKit

final class SubCategoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    private func configureViews() {
        titleLabel.font = UIFont.font(.primaryMedium, .medium)
    }
    
    func configure(with category: Category?) {
        titleLabel.text = category?.name ?? "N/A"
    }
}
