//
//  Fonts.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 04/01/2021.
//

import UIKit

extension UIFont {
    
    /// Predefined font sizes
    enum FontSize: CGFloat {
        /// 5
        case micro = 5
        /// 10
        case tiny = 10
        /// 12
        case small = 12
        /// 14
        case little = 14
        /// 16
        case medium = 16
        /// 18
        case big = 18
        /// 20
        case huge = 20
        /// 25
        case gigantic = 25
    }
    
    /// Predefined font types
    enum FontType: String {
        /// Montserrat-Bold
        case primaryBold = "Montserrat-Bold"
        /// Montserrat-ExtraBold
        case primaryExtraBold = "Montserrat-ExtraBold"
        /// Montserrat-ExtraLight
        case primaryExtraLight = "Montserrat-ExtraLight"
        /// Montserrat-Light
        case primaryLight = "Montserrat-Light"
        /// Montserrat-Medium
        case primaryMedium = "Montserrat-Medium"
        /// Montserrat-Regular
        case primaryRegular = "Montserrat-Regular"
        /// Montserrat-SemiBold
        case primarySemiBold = "Montserrat-SemiBold"
        /// Montserrat-Thin
        case primaryThin = "Montserrat-Thin"
    }
    
    static func font(_ fontType: FontType, _ fontSize: FontSize) -> UIFont {
        return UIFont(name: fontType.rawValue, size: fontSize.rawValue) ?? UIFont.systemFont(ofSize: fontSize.rawValue)
    }
    
    static func font(_ fontType: FontType, _ size: CGFloat) -> UIFont {
        return UIFont(name: fontType.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
