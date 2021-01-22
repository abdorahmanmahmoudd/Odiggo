//
//  UIBarButtonItem.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 09/01/2021.
//

import UIKit

extension UIBarButtonItem {
    
    static func odiggoBackButton(target: UIViewController, action: Selector, tintColor: UIColor = .white) -> UIBarButtonItem? {
        
        guard (target.navigationController?.viewControllers.count ?? 0) > 1 else {
            return nil
        }
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back-icon"), for: .normal)
        backButton.tintColor = tintColor
        
        let widthConstraint = backButton.widthAnchor.constraint(equalToConstant: 40)
        widthConstraint.priority = .defaultLow
        widthConstraint.isActive = true
        
        backButton.addTarget(target, action: action, for: .touchUpInside)
        backButton.imageView?.contentMode = .center

        let barButtonItem = UIBarButtonItem(customView: backButton)
        return barButtonItem
    }
    
    static func searchPlaceholderItem(target: UIViewController, action: Selector) -> UIBarButtonItem? {
        
        /// Prepare text field
        let searchTextField = OTextField()
        searchTextField.textfieldType = .searchField
        searchTextField.setPlaceHolder(text: "SEARCH_HERE_PLACEHOLDER".localized)
        
        /// Configure contraints
        let viewWidth = UIScreen.main.bounds.width * 0.845
        searchTextField.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        /// Register tap gesture action
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        searchTextField.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = true
        
        return UIBarButtonItem(customView: searchTextField)
    }
    
    // This function is used to return 45 by 45 buttons
    static func customBarButtonItem(image: UIImage? = nil,
                                    title: String? = nil,
                                    selector: Selector? = nil,
                                    backgroundImage: UIImage? = nil,
                                    target: Any? = nil) -> UIBarButtonItem {

        let button = UIButton(type: .custom)
        if let image = image {
            button.setImage(image, for: .normal)
        }

        if let title = title, !title.isEmpty {
            button.setTitle(title, for: .normal)
        }

        if let selector = selector {
            button.addTarget(target, action: selector, for: .touchUpInside)
        }

        button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        button.imageView?.clipsToBounds = false
        button.imageView?.contentMode = .center
        button.setBackgroundImage(backgroundImage, for: .normal)
    
        return UIBarButtonItem(customView: button)
    }
}
