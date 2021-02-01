//
//  ProductDetailsViewController+Snap.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 28/01/2021.
//

import UIKit

extension ProductDetailsViewController {
    
    enum SnapPosition {
        case top, bottom
    }
    
    func snapUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.imageContainerHeightConstraint.constant = 0
            self.productDetailsView.scrollView.isScrollEnabled = false
            self.view.layoutIfNeeded()
            
        }, completion: { [weak self] _ in
            
            self?.isPanGesturing = false
            self?.currentSnapPosition = .top
        })
    }

    func snapDown() {

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {

            self.imageContainerHeightConstraint.constant = -UIScreen.main.bounds.height * self.minImagesContainerViewHeightPercentage
            self.productDetailsView.scrollView.isScrollEnabled = true
            self.view.layoutIfNeeded()
            
        }, completion: { [weak self] _ in
            
            self?.setCurrentPage(0)
            self?.isPanGesturing = false
            self?.currentSnapPosition = .bottom
        })
    }
}
