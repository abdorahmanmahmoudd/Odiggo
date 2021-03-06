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
    
    private(set) var userManager: UserManager
    
    /// Coordinator navigation controller
    var navigationController: UINavigationController
    
    /// Main Tabbar Controller
    var tabbarController: UITabBarController?

    /// An array to track the childs coordinators
    var childCoordinators: [Coordinator] = []
    
    init(_ window: UIWindow, _ apiClient: API = API(), _ userManager: UserManager? = nil) {
        
        navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        navigationController.navigationBar.isTranslucent = true
        
        tabbarController = UITabBarController()
        
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        
        self.api = apiClient
        self.userManager = UserManager(api: api)
    }
    
    /// Starting point
    func start() {

        if !userManager.onboardingCompleted {
            startOnboarding()
            
        } else if userManager.isAuthenticated {
            startTabbarController()
            
        } else {
            startAuthentication()
        }
        
    }
    
    func startTabbarController() {

        /// Setup `ProductsCoordinator` & start it.
        let productsCoordinator = ProductsCoordinator(navigationController, api)
        addChildCoordinator(productsCoordinator)
        productsCoordinator.start()

        /// Configure TabbarController view controllers
        let viewControllers = [productsCoordinator.rootViewController].compactMap({ $0 })
        tabbarController?.setViewControllers(viewControllers, animated: true)

        guard let tabbarVC = tabbarController else {
            fatalError("tabbarVC is not initialized")
        }
        
        /// Set navigationController root viewController
        navigationController.setViewControllers([tabbarVC], animated: true)
    }
    
    func startOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController)
        onboardingCoordinator.parentCoordinator = self
        addChildCoordinator(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func startAuthentication() {
        let authenticationCoordiantor = AuthenticationCoordinator.init(navigationController, api, userManager)
        authenticationCoordiantor.parentCoordinator = self
        addChildCoordinator(authenticationCoordiantor)
        authenticationCoordiantor.start()
    }
}

// MARK: Additional behaviour
extension AppCoordinator {
    
    func childDidFinish(_ child: Coordinator) {
        
        removeChildCoordinator(child)
        
        switch child.self {
        case is OnboardingCoordinator:
            userManager.onboardingCompleted = true
            startAuthentication()
            
        case is AuthenticationCoordinator:
            startTabbarController()
            
        default:
            debugPrint("childDidFinish not handling \(child)")
        }
    }
}

