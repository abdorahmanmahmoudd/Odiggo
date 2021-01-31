//
//  RelatedProductCollectionViewCell.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 31/01/2021.
//

import UIKit
import Nuke

final class RelatedProductCollectionViewCell: UICollectionViewCell {

    /// UI Outlets
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        containerView.layer.shadow(shadow: .roundedCardShadow(radius: 5))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        priceLabel.text = nil
        productNameLabel.text = nil
        productImageView.image = nil
    }

    func configure(_ product: Product?) {
        
        priceLabel.attributedText = "\(product?.sale_price ?? 0)".priceLabeled(.tiny, .micro, with: .pinkishRed)
        productNameLabel.text = product?.name
        
        if let urlString = product?.featuredImage, let imageURL = URL(string: urlString) {
            Nuke.loadImage(with: imageURL, into: productImageView)
        } else {
            productImageView.image = #imageLiteral(resourceName: "tire.placeholder.icon")
        }
    }

}
