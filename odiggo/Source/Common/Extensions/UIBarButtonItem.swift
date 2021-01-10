//
//  UIBarButtonItem.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 09/01/2021.
//

import UIKit

extension UIBarButtonItem {
    
    static func odiggoBackButton(target: UIViewController, selector: Selector) -> UIBarButtonItem? {
        
        guard (target.navigationController?.viewControllers.count ?? 0) > 1 else {
            return nil
        }

        let backButton = UIBarButtonItem(image: UIImage(named: "back-icon"),
                                         style: .plain,
                                         target: target,
                                         action: selector)
        backButton.tintColor = .white
        
        /// Make width a big bigger than default 30 to make this easily tappable
        backButton.width = 50
        return backButton
    }
}
