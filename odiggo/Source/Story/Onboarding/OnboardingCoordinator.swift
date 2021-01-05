//
//  OnboardingCoordinator.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 02/01/2021.
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: Coordinator?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
    
        let onboardingVC = OnboardingViewController.init()
        onboardingVC.coordinator = self
        navigationController.setViewControllers([onboardingVC], animated: true)
    }
}

// MARK: Additional behaviour
extension OnboardingCoordinator {
    
    /// After pop animation is done etc..
    func didFinish() {
        (parentCoordinator as? AppCoordinator)?.childDidFinish(self)
    }
}
