//
//  ShadowStyle.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 30/01/2021.
//

import UIKit

// MARK: Shadows Enum representing the reusable shadow styles
enum Shadows {
    
    case cardShadow
    case roundedCardShadow(radius: CGFloat)
    
    func shadowStyle() -> ShadowStyle {
        switch self {
        case .cardShadow:
            return CardShadow()
        case .roundedCardShadow(_):
            return RoundedCardShadow()
        }
    }
}

// MARK: A protocol to define different type of shadow styles
protocol ShadowStyle {
    var color: UIColor { get }
    var opacity: Float { get }
    var inset: Bool { get }
    var hOffset: CGFloat { get }
    var vOffset: CGFloat { get }
    var blurRadius: CGFloat { get }
    var spread: CGFloat { get }
}

// Example of a predefined shadow style
private struct CardShadow: ShadowStyle {
    let color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    let opacity: Float = 0.16
    let inset: Bool = false
    let hOffset: CGFloat = 0
    let vOffset: CGFloat = 3
    let blurRadius: CGFloat = 50
    let spread: CGFloat = 1
}

private struct RoundedCardShadow: ShadowStyle {
    let color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    let opacity: Float = 0.08
    let inset: Bool = false
    let hOffset: CGFloat = 0
    let vOffset: CGFloat = 0
    let blurRadius: CGFloat = 15
    let spread: CGFloat = 1
}


