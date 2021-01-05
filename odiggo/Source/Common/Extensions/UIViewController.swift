//
//  UIViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 04/01/2021.
//

import UIKit

extension UIViewController {
    
    /// This function is used to load the ViewController from the Storyboard file
    /// Make sure that:
    /// 1-  The ViewController class name should match the storyboard file name
    /// 2- the ViewController is in the storyboard
    /// - Returns: Instance of the ViewController type
    static func loadFromStoryboard() -> Self {
        
        let storyboard = UIStoryboard(name: String(describing: Self.self), bundle: nil)
        
        if let vc = storyboard.instantiateInitialViewController() as? Self {
            return vc
            
        } else if let vc = (storyboard.instantiateViewController(withIdentifier: String(describing: Self.self)) as? Self) {
            return vc
        }
        fatalError("Couldn't find storyboard named \(String(describing: Self.self))")
    }
}
