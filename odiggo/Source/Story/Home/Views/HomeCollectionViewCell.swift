//
//  HomeCollectionViewCell.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 16/01/2021.
//

import UIKit
import Nuke

final class HomeCollectionViewCell: UICollectionViewCell {

    /// UI Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        descriptionLabel.text = nil
        titleLabel.text = nil
    }
    
    func calculateHeight() -> CGFloat {
        /// default implementation to get height of the view
        let defaultSize = CGSize(width: UIScreen.main.bounds.width / 2, height: 50)
        let newSize = contentView.systemLayoutSizeFitting(defaultSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultLow)
        return newSize.height
    }
    
    private func configureViews() {
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 15
    }
    
    func configure(_ category: Category?, _ backgroundColor: UIColor.Colors) {
        
        containerView.backgroundColor = UIColor.color(color: backgroundColor)

        titleLabel.text = category?.name
        descriptionLabel.text = category?.description
 
        if let urlString = category?.banner_image, let imageURL = URL(string: urlString) {
            Nuke.loadImage(with: imageURL, into: imageView)
        } else {
            imageView.image = #imageLiteral(resourceName: "progress_circular")
        }
        layoutIfNeeded()
    }
}
