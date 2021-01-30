//
//  ProductImageCollectionViewCell.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 28/01/2021.
//

import UIKit
import Nuke

final class ProductImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        guard let superview = superview else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        let autoLayoutAttributes = layoutAttributes
        let autoLayoutSize = CGSize(width: superview.frame.width,
                                    height: superview.frame.height / 1.59)
        
        let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin,
                                     size: autoLayoutSize)
        /// Assign the new size to the layout attributes
        autoLayoutAttributes.frame = autoLayoutFrame
        super.preferredLayoutAttributesFitting(autoLayoutAttributes)
        
        return autoLayoutAttributes
    }
    
    func configure(with url: String?) {
        
        if let urlString = url , let imageURL = URL(string: urlString) {
            Nuke.loadImage(with: imageURL, into: imageView)
        } else {
            imageView.image = #imageLiteral(resourceName: "tire.placeholder.icon")
        }
    }
}
