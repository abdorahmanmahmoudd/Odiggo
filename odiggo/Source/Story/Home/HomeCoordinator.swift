//
//  HomeCoordinator.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 10/01/2021.
//

import UIKit

final class HomeCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: Coordinator?
    
    var api: NetworkRepository
    
    init(_ navigationController: UINavigationController, _ api: NetworkRepository) {
        self.navigationController = navigationController
        self.api = api
    }
    
    func start() {
        
        let homeVM = HomeViewModel(api.homeRepository)
        let homeVC = HomeViewController.create(payload: homeVM)
        homeVC.coordinator = self
        navigationController.setViewControllers([homeVC], animated: true)
    }
}

//// MARK: Additional behaviour
//extension HomeCoordinator {
//    
//    /// After pop animation is done etc..
//    func didFinish() {
//        (parentCoordinator as? TabBarCoordinator)?.childDidFinish(self)
//    }
//}

