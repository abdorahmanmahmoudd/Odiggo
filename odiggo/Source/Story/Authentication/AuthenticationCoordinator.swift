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
    
    var userManager: UserManager
    
    init(_ navigationController: UINavigationController, _ api: NetworkRepository, _ userManager: UserManager) {
        self.navigationController = navigationController
        self.api = api
        self.userManager = userManager
    }
    
    func start() {
        
        let loginVM = LoginViewModel(userManager)
        let LoginVC = LoginViewController.create(payload: loginVM)
        LoginVC.coordinator = self
        navigationController.setViewControllers([LoginVC], animated: false)
    }
    
    func startSignup() {
        
        let signupVM = SignupViewModel(userManager)
        let signupVC = SignupViewController.create(payload: signupVM)
        signupVC.coordinator = self
        navigationController.pushViewController(signupVC, animated: true)
    }
    
    func startForgetPassword() {
        
        let forgetPasswordVM = ForgetPasswordViewModel(api.authenticationRepository)
        let forgetPasswordVC = ForgetPasswordViewController.create(payload: forgetPasswordVM)
        forgetPasswordVC.coordinator = self
        navigationController.pushViewController(forgetPasswordVC, animated: true)
    }
    
    func loginTapped() {
        navigationController.popViewController(animated: true)
    }
}

// MARK: Additional behaviour
extension AuthenticationCoordinator {
    
    /// After finishing a ViewController journey
    func didFinish(_ viewController: UIViewController) {
                
        switch viewController {
        case is ForgetPasswordViewController:
            navigationController.popViewController(animated: true)
            
        default:
            (parentCoordinator as? AppCoordinator)?.childDidFinish(self)
        }
    }
}
