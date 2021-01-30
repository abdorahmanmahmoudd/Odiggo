//
//  UIView.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import UIKit

// MARK: UI Helper functions
extension UIView {
    
    /// Helper method to activate constraints for a UIView
    @objc func activateConstraints(for view: UIView) {

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Helper method to load view from nib files
    func loadNib() -> UIView? {

        guard let xib = Bundle.main.loadNibNamed(String(describing: self.classForCoder.self),
                                                 owner: self,
                                                 options: nil)?.first as? UIView else {
                return nil
        }
        
        return xib
    }
    
    /// Helper method to apply corner radius for selected directions
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

// MARK: UIView+ReusableIdentifier
extension UIView: ReusableIdentifier {}
