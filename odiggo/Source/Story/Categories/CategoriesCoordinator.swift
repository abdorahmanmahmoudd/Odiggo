//
//  CategoriesCoordinator.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 17/01/2021.
//

import UIKit

final class CategoriesCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: Coordinator?
    
    var api: NetworkRepository
    
    init(_ navigationController: UINavigationController, _ api: NetworkRepository) {
        self.navigationController = navigationController
        self.api = api
    }
    
    func start() {
        
        let categoriesVM = CategoriesViewModel(api.homeRepository)
        let categoriesVC = CategoriesViewController.create(payload: categoriesVM)
        categoriesVC.coordinator = self
        parentCoordinator?.addChildCoordinator(self)
        navigationController.setViewControllers([categoriesVC], animated: false)
    }
    
    func selectCategory(_ category: Category) {
        debugPrint("Abdo: selectCategory \(category.name)")
    }
}

// MARK: Additional behaviour
extension CategoriesCoordinator {
    
    /// After pop animation is done etc..
    func didFinish() {
        (parentCoordinator as? TabBarCoordinator)?.childDidFinish(self)
    }
}
