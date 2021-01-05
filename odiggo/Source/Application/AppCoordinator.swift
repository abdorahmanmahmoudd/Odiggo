//
//  AppCoordinator.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import UIKit

// MARK: Application main Coordinator that should kick off the app flow
final class AppCoordinator: Coordinator {
    
    /// Main Application window
    private(set) var window: UIWindow
    
    /// App API shared client
    private(set) var api: API
    
    /// Coordinator navigation controller
    var navigationController: UINavigationController
    
    /// Main Tabbar Controller
    var tabbarController: UITabBarController?

    /// An array to track the childs coordinators
    var childCoordinators: [Coordinator] = []
    
    init(_ window: UIWindow, _ apiClient: API = API()) {
        
        navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        navigationController.navigationBar.isTranslucent = true
        
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        
        self.api = apiClient
    }
    
    /// Starting point
    func start() {
//        startTabbarController()
        startOnboarding()
    }
    
//    func startTabbarController() {
//
//        /// Setup `ProductsListCoordinator` & start it.
//        let productsListCoordinator = ProductsListCoordinator(api)
//        addChildCoordinator(productsListCoordinator)
//        productsListCoordinator.start()
//
//        /// Configure TabbarController view controllers
//        let viewControllers = [productsListCoordinator.navigationController]
//        tabbarController.setViewControllers(viewControllers, animated: true)
//
//        /// Set navigationController root viewController
//        navigationController.setViewControllers([tabbarController], animated: true)
//    }
    
    func startOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController)
        onboardingCoordinator.parentCoordinator = self
        addChildCoordinator(onboardingCoordinator)
        onboardingCoordinator.start()
    }
}

// MARK: Additional behaviour
extension AppCoordinator {
    
    func childDidFinish(_ child: Coordinator) {
        
        switch child.self {
        case is OnboardingCoordinator:
            debugPrint("OnboardingCoordinator didFinish")
            
        default:
            debugPrint("childDidFinish not handling \(child)")
        }
        
        removeChildCoordinator(child)
    }
}

