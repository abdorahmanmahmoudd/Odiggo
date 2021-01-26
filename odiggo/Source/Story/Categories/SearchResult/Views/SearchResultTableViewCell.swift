//
//  SearchResultTableViewCell.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 26/01/2021.
//

import UIKit
import Nuke

final class SearchResultTableViewCell: UITableViewCell {

    /// UI Outlets
    @IBOutlet private weak var cartButton: UIButton!
    @IBOutlet private weak var favouriteButton: FavouriteButton!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var reviewsLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var rateIcon: UIImageView!
    @IBOutlet private weak var productImageView: UIImageView!
    
    /// Closures
    var cartButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        priceLabel.text = nil
        reviewsLabel.text = nil
        rateLabel.text = nil
        titleLabel.text = nil
        favouriteButton.reset()
    }
    
    private func configureViews() {
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 20
        cartButton.titleLabel?.font = UIFont.font(.primarySemiBold, .little)
        
        reviewsLabel.font = UIFont.font(.primaryMedium, 13)
        rateLabel.font = UIFont.font(.primaryMedium, 13)
        titleLabel.font = UIFont.font(.primaryBold, 13)
        
        rateIcon.image = UIImage(named: "star.icon")
        productImageView.image = UIImage(named: "tire.placeholder.icon")
    }
    
    func configure(with product: Product?) {
        
        titleLabel.text = product?.name
        reviewsLabel.text = "(\(product?.count_feedback ?? 0))"
        rateLabel.text = "\(product?.average_feedback ?? 0)"
        priceLabel.attributedText = "\(product?.sale_price ?? 0)".priceLabeled()
    
        if let id = product?.id {
            favouriteButton.bind(to: id)
        }
        
        if let urlString = product?.featuredImage, let imageURL = URL(string: urlString) {
            Nuke.loadImage(with: imageURL, into: productImageView)
        }
    }
    
    @IBAction func cartButtonTapped(_ sender: UIButton) {
        debugPrint("cartButtonTapped")
        cartButtonAction?()
    }
}
