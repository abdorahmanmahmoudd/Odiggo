//
//  UINavigationController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 21/01/2021.
//

import UIKit

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return visibleViewController?.preferredStatusBarStyle ?? .default
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
}
//
//func position(for bar: UIBarPositioning) -> UIBarPosition {
//    return .topAttached
//}
