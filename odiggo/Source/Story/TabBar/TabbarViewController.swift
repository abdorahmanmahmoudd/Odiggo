//
//  TabbarViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 16/01/2021.
//

import UIKit

final class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private var middleImageIndex: Int = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return selectedViewController?.preferredStatusBarStyle ?? .default
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
                
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        
        guard var viewControllers = viewControllers, viewControllers.count > 0 else {
            super.setViewControllers([], animated: animated)
            return
        }
        
        if viewControllers.count < 3 {
            middleImageIndex = 1
            
        } else if viewControllers.count == 3 {
            viewControllers.append(unselectableVC())
            middleImageIndex = 2
            
        } else if viewControllers.count == 4 {
            middleImageIndex = 2
        }
        viewControllers.insert(unselectableVC(), at: middleImageIndex)
        
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard viewController.tabBarItem.tag >= 0 else {
            return false
        }
        return true
    }
    
    
    private func unselectableVC() -> UIViewController {
        let unselectableViewController = UIViewController()
        unselectableViewController.tabBarItem = UITabBarItem(title: nil, image: nil, tag: -1)
        return unselectableViewController
    }
}
