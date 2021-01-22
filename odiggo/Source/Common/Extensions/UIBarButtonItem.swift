//
//  UIBarButtonItem.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 09/01/2021.
//

import UIKit

extension UIBarButtonItem {
    
    static func odiggoBackButton(target: UIViewController, selector: Selector, tintColor: UIColor = .white) -> UIBarButtonItem? {
        
        guard (target.navigationController?.viewControllers.count ?? 0) > 1 else {
            return nil
        }
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back-icon"), for: .normal)
        backButton.tintColor = tintColor
        
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.addTarget(target, action: selector, for: .touchUpInside)
        backButton.imageView?.contentMode = .center

        let barButtonItem = UIBarButtonItem(customView: backButton)
        barButtonItem.customView?.frame.origin.x -= 16
        return barButtonItem
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
