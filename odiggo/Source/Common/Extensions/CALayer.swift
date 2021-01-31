//
//  CALayer.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 30/01/2021.
//

import UIKit
 
extension CALayer {
    
    /// A helper function to apply shadow style
    func shadow(shadow: Shadows) {
        
        let style = shadow.shadowStyle()
        
        if case .roundedCardShadow(let radius) = shadow {
            roundedShadow(with: radius, style: style)
            return
        }

        shadowColor = style.color.cgColor
        shadowOpacity = style.opacity
        shadowOffset = CGSize(width: style.hOffset, height: style.vOffset)
        shadowRadius = style.blurRadius

        if style.spread == 0 {
            shadowPath = nil
            
        } else {
            let deltaX = -style.spread
            let rect = bounds.insetBy(dx: deltaX, dy: deltaX)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    private func roundedShadow(with cornerRadius: CGFloat, style: ShadowStyle) {
        
        let shadowLayer: CAShapeLayer = (sublayers?.first(where: { $0 is CAShapeLayer }) as? CAShapeLayer) ?? CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = style.color.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: style.hOffset, height: style.vOffset)
        shadowLayer.shadowOpacity = style.opacity
        shadowLayer.shadowRadius = style.blurRadius
        
        insertSublayer(shadowLayer, at: 0)
    }
}
