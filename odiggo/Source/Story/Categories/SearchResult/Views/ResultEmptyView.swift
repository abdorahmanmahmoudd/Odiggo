//
//  ResultEmptyView.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 26/01/2021.
//

import UIKit

final class ResultEmptyView: UIView {

    /// UI Outlets
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    private func configureViews() {
        titleLabel.font = UIFont.font(.primaryBold, .huge)
        descriptionLabel.font = UIFont.font(.primaryLight, .little)
        
        titleLabel.textColor = UIColor.color(color: .greyishBrown)
        descriptionLabel.textColor = UIColor.color(color: .warmGreyTwo)
    }
    
    func configure(with image: String, title: String, description: String) {
        backgroundImageView.image = UIImage(named: image)
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
