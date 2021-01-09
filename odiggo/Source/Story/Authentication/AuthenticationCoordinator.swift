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
    
    var api: NetworkRepository
    
    init(_ navigationController: UINavigationController, _ api: NetworkRepository) {
        self.navigationController = navigationController
        self.api = api
    }
    
    func start() {
        
        let loginVM = LoginViewModel(api.authenticationRepository)
        let LoginVC = LoginViewController.create(payload: loginVM)
        LoginVC.coordinator = self
        navigationController.setViewControllers([LoginVC], animated: true)
    }
    
    func startSignup() {
        
        let signupVM = SignupViewModel(api.authenticationRepository)
        let signupVC = SignupViewController.create(payload: signupVM)
        signupVC.coordinator = self
        navigationController.pushViewController(signupVC, animated: true)
    }
    
    func loginTapped() {
        navigationController.popViewController(animated: true)
    }
}

// MARK: Additional behaviour
extension AuthenticationCoordinator {
    
    /// After pop animation is done etc..
    func didFinish() {
        (parentCoordinator as? AppCoordinator)?.childDidFinish(self)
    }
}
