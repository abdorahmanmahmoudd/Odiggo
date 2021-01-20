//
//  UITabbarItem.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 20/01/2021.
//

import UIKit

extension UITabBarItem {
    
    static func odiggoItem(ofType type: OdiggoTab) -> UITabBarItem {
        
        switch type {
        case .home:
            return UITabBarItem(title: nil, image: UIImage(named: "home.unselected.icon"),
                                selectedImage: UIImage(named: "home.selected.icon"))
        
        case .categories:
            return UITabBarItem(title: nil, image: UIImage(named: "categories.unselected.icon"),
                                selectedImage: UIImage(named: "categories.selected.icon"))
            
        case .cart:
            return UITabBarItem(title: nil, image: UIImage(named: "cart.unselected.icon"),
                                selectedImage: UIImage(named: "cart.selected.icon"))
            
        case .more:
            return UITabBarItem(title: nil, image: UIImage(named: "more.unselected.icon"),
                                selectedImage: UIImage(named: "more.selected.icon"))
        }
    }
    
    enum OdiggoTab {
        case home
        case categories
        case cart
        case more
    }
}
