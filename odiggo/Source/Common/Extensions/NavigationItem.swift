//
//  ONavigationItem.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 14/01/2021.
//

import UIKit

enum NavigationItemStyle {
    case homePageStyle(items: [UIBarButtonItem])
    case searchPlaceHolderStyle(items: [UIBarButtonItem])
    case resultStyle(title: String, items: [UIBarButtonItem])
}

extension UINavigationItem {
    
    func configure(with style: NavigationItemStyle) {

        /// Make sure our title is empty
        title = ""

        switch style {
        case .homePageStyle(let items):
            configureHomePageLogo()
            rightBarButtonItems = items
            
        case .searchPlaceHolderStyle(let items):
            setHidesBackButton(true, animated: false)
            leftBarButtonItems = items
            
        case .resultStyle(let title, let items):
            setHidesBackButton(true, animated: false)
            leftBarButtonItems = items
            configureTitleView(with: title)
            
        }
    }
    
    private func configureHomePageLogo() {
        let logoImage = UIImage(named: "home.logo")
        let logoImageView = UIImageView(image: logoImage)
        let barButtonItem = UIBarButtonItem(customView: logoImageView)
        leftBarButtonItem = barButtonItem
    }
    
    private func configureTitleView(with title: String) {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.font(.primaryBold, .huge)
        titleLabel.textColor = UIColor.color(color: .greyishBrown)
        titleLabel.text = title
        titleView = titleLabel
    }
}
