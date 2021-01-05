//
//  UIColor.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 02/01/2021.
//

import UIKit

extension UIColor {
    
    // Use this method to obtain custom colors defined in colors enum and in assets
    static func color(color: UIColor.Colors) -> UIColor {
        return assetColor(named: color.rawValue)
    }

    private static func assetColor(named name: String) -> UIColor {
        return UIColor(named: name) ?? UIColor.white
    }
}

