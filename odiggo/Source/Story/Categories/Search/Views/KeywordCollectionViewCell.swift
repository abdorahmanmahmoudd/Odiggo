//
//  KeywordCollectionViewCell.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 23/01/2021.
//

import UIKit

final class KeywordCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
    
    private func configureViews() {
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 23
        titleLabel.font = UIFont.font(.primarySemiBold, .medium)
    }
    
    func configure(_ keyword: String?) {
        titleLabel.text = keyword
    }
}

