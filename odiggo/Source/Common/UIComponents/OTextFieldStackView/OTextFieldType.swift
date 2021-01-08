//
//  OTextFieldType.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 07/01/2021.
//

import UIKit

enum OTextFieldType: Int {
    
    case password = 0
    case disabled
    case username
    
    var image: UIImage {
        switch self {
        case .password:
            return UIImage(named: "password-icon") ?? UIImage()
        case .disabled:
            return UIImage()
        case .username:
            return UIImage(named: "username-icon") ?? UIImage()
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .password:
            return UIImage(named: "password-icon") ?? UIImage()
        case .disabled:
            return UIImage()
        case .username:
            return UIImage(named: "username-icon") ?? UIImage()
        }
    }
    
    var inactiveBorderColor: CGColor {
        switch self {
        default:
            return UIColor.clear.cgColor
        }
    }
    
    var activeBorderColor: CGColor {
        return UIColor.color(color: .pinkishRed).withAlphaComponent(0.3).cgColor
    }
}
