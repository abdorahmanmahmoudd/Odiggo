//
//  ProductDetailsView.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 29/01/2021.
//

import UIKit

final class ProductDetailsView: UIView {

    @IBOutlet private weak var handleView: UIView!
    @IBOutlet private(set) weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        handleView.roundCorners(corners: [.topRight, .topLeft], radius: 22)
    }
    
    private func configureViews() {
        handleView.roundCorners(corners: [.topRight, .topLeft], radius: 22)
    }
}
