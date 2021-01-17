//
//  UIImageView.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 14/01/2021.
//

import UIKit

extension UIImageView {
    
    func scaled(with height: CGFloat) -> UIImageView {
        
        let aspectRatio: CGFloat = height / frame.height
        let imageWidth: CGFloat = frame.width * aspectRatio
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        contentMode = .scaleAspectFit
        return self
    }
}
