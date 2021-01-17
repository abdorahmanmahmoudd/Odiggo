//
//  ONavigationItem.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 14/01/2021.
//

import UIKit

enum NavigationItemStyle {
    case homePageStyle(items: [UIBarButtonItem])
}

extension UINavigationItem {
    
    func configure(with style: NavigationItemStyle) {

        /// Make sure our title is empty
        title = ""

        switch style {
        case let .homePageStyle(items):
            configureHomePageLogo()
            rightBarButtonItems = items
        }
    }
    
    private func configureHomePageLogo() {
        let logoImage = UIImage(named: "home.logo")
        let logoImageView = UIImageView(image: logoImage)
        let barButtonItem = UIBarButtonItem(customView: logoImageView)
        leftBarButtonItem = barButtonItem
    }
}
