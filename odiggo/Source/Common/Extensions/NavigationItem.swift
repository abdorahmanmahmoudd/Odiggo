//
//  ONavigationItem.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 14/01/2021.
//

import UIKit

enum NavigationItemStyle {
    case homePageStyle(items: [UIBarButtonItem])
    case searchPlaceHolderStyle(Any, Selector)
}

extension UINavigationItem {
    
    func configure(with style: NavigationItemStyle) {

        /// Make sure our title is empty
        title = ""

        switch style {
        case let .homePageStyle(items):
            configureHomePageLogo()
            rightBarButtonItems = items
            
        case .searchPlaceHolderStyle(let target, let action):
            configureSearchPlaceHolder(with: target, action: action)
        }
    }
    
    private func configureHomePageLogo() {
        let logoImage = UIImage(named: "home.logo")
        let logoImageView = UIImageView(image: logoImage)
        let barButtonItem = UIBarButtonItem(customView: logoImageView)
        leftBarButtonItem = barButtonItem
    }
    
    private func configureSearchPlaceHolder(with target: Any, action: Selector) {
        
        /// Prepare text field
        let searchTextField = OTextField()
        searchTextField.textfieldType = .searchField
        searchTextField.setPlaceHolder(text: "SEARCH_HERE_PLACEHOLDER".localized)
        
        /// Prepare containerView
        let viewContainer = UIView()
        viewContainer.addSubview(searchTextField)
        searchTextField.activateConstraints(for: viewContainer)
        
        /// Configure contraints
        let viewWidth = UIScreen.main.bounds.width * 0.8 /// 0.845
        viewContainer.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        viewContainer.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        /// Register tap gesture action
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        searchTextField.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = true

        titleView = viewContainer
    }
}
