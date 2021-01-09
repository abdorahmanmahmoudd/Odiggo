//
//  OTextFieldType.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 07/01/2021.
//

import UIKit

enum OTextFieldType {
    
    case password
    case disabled
    case email
    case username
    
    var image: UIImage {
        switch self {
        case .password:
            return UIImage(named: "password-icon") ?? UIImage()
        case .disabled:
            return UIImage()
        case .username:
            return UIImage(named: "username-icon") ?? UIImage()
        case .email:
            return UIImage(named: "email-icon") ?? UIImage()
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
        case .email:
            return UIImage(named: "email-icon") ?? UIImage()
        }
    }
    
    var inactiveBorderColor: CGColor {
        return UIColor.clear.cgColor
    }
    
    var activeBorderColor: CGColor {
        return UIColor.color(color: .warmGreyTwo).withAlphaComponent(0.3).cgColor
    }
}
