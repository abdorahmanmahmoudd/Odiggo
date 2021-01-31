//
//  CAGradientLayer.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 30/01/2021.
//

import UIKit

// TODO: Not used at the moment.
extension CAGradientLayer {

    enum GradientStyle {
        case fill
        case topToBottom
        case bottomToTop
        case radial
        case tail
        case none
        case transparent

        func gradientColors() -> [CGColor] {
            switch self {
            case .fill:
                return [UIColor(white: 0, alpha: 0.33).cgColor, UIColor(white: 0, alpha: 0.33).cgColor]
            case .topToBottom, .bottomToTop:
                return [UIColor(white: 0, alpha: 0.33).cgColor, UIColor.clear.cgColor]
            case .radial:
                return [UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.12).cgColor, UIColor(white: 0, alpha: 0.33).cgColor]
            case .tail:
                return [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor] /// that will show the first two parts and fade the last part.
            case .transparent:
                return [UIColor(white: 1, alpha: 0.24).cgColor, UIColor(white: 1, alpha: 0.88).cgColor]
            default:
                return []
            }
        }
    }

    static func gradientLayer(with style: GradientStyle, frame: CGRect) -> CAGradientLayer? {
        let gradient = CAGradientLayer()
        gradient.colors = style.gradientColors()

        switch style {
        case .fill:
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
            gradient.type = .axial
        case .topToBottom:
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
            gradient.type = .axial
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1)
            gradient.endPoint = CGPoint(x: 0.5, y: 0)
            gradient.type = .axial
        case .radial:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            gradient.locations = [0, 0.7, 1]
            gradient.type = .radial
        case .tail:
            gradient.locations = [0, 0.58, 1.0] /// that will fade the last part of the view
        case .transparent:
            gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
            gradient.locations = [0, 1]
            gradient.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        case .none:
            break
        }
        
        gradient.frame = frame
        return gradient
    }
}
