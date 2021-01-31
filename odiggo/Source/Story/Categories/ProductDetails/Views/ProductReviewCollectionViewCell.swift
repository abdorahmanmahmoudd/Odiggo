//
//  ProductReviewCollectionViewCell.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 30/01/2021.
//

import UIKit

final class ProductReviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var feedbackLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var profilePicImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        containerView.layer.shadow(shadow: .roundedCardShadow(radius: 5))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        feedbackLabel.text = nil
        rateLabel.text = nil
        nameLabel.text = nil
        profilePicImageView.image = nil
    }

    
    func configure(_ feedback: Feedback?) {
        feedbackLabel.text = feedback?.comment
        rateLabel.text = "\(feedback?.rating ?? 0)"
        nameLabel.text = "N/A"
        profilePicImageView.image = UIImage(named: "profile.pic")
    }
}
