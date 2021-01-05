//
//  Injectable.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import UIKit

/// A protocl used to inject the view model into the view controller.
protocol Injectable {
    
    /// The type that indicates what we will inject
    associatedtype Payload
    
    /// Inject the given type into the given ViewController
    func inject(payload: Payload)
    
    /**
     Should check if the injection was sucessfull
     - note: It should be noted that if the payload is not successfully injected the application should crash
     */
    func assertInjection()
}

// MARK: Injectable+UIViewController
extension Injectable where Self: UIViewController {

    /**
     Creates a UIViewController of a given type
     - parameter payload: The payload we want to inject into our ViewController
     - returns: A UIViewController
     */
    static func create(payload: Payload) -> Self {
        
        // Construct the ViewController
        let viewController = self.init()
        
        viewController.inject(payload: payload)
        viewController.assertInjection()
        
        return viewController
    }
}

// MARK: Injectable+UIView
extension Injectable where Self: UIView {

    // Create a UIView with Identifier and inject it with a payload
    static func create(payload: Payload) -> Self {

        let view = self.init()

        view.inject(payload: payload)
        view.assertInjection()

        return view
    }
}
