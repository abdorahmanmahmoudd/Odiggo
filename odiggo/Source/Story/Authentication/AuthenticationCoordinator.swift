//
//  AuthenticationCoordinator.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 07/01/2021.
//

import UIKit

final class AuthenticationCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: Coordinator?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
    
        let LoginVC = LoginViewController.init()
        LoginVC.coordinator = self
        navigationController.setViewControllers([LoginVC], animated: true)
    }
}

// MARK: Additional behaviour
extension AuthenticationCoordinator {
    
    /// After pop animation is done etc..
    func didFinish() {
        (parentCoordinator as? AppCoordinator)?.childDidFinish(self)
    }
}
