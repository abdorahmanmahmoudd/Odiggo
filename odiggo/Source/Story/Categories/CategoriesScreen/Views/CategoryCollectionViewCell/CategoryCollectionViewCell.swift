//
//  CategoryCollectionViewCell.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 20/01/2021.
//

import UIKit
import Nuke

final class CategoryCollectionViewCell: UICollectionViewCell {

    /// UI Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverImageView.image = nil
        titleLabel.text = nil
    }
    
    private func configureViews() {
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 5
        titleLabel.font = UIFont.font(.primarySemiBold, 17)
    }
    
    func configure(_ category: Category?) {
        titleLabel.text = category?.name
 
        if let urlString = category?.banner_image, let imageURL = URL(string: urlString) {
            Nuke.loadImage(with: imageURL, into: coverImageView)
        } else {
            coverImageView.image = #imageLiteral(resourceName: "progress_circular")
        }
    }
}
