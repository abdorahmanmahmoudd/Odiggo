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
        
        let categoriesVM = CategoriesViewModel(api.categoriesRepository)
        let categoriesVC = CategoriesViewController.create(payload: categoriesVM)
        categoriesVC.coordinator = self
        parentCoordinator?.addChildCoordinator(self)
        navigationController.setViewControllers([categoriesVC], animated: false)
    }
    
    func startSubCategories(with category: Category) {
        
        let subCategoriesVM = SubCategoriesViewModel(api.categoriesRepository, category: category)
        let subCategoriesVC = SubCategoriesViewController.create(payload: subCategoriesVM)
        subCategoriesVC.coordinator = self
        navigationController.pushViewController(subCategoriesVC, animated: false)
    }
    
    func selectCategory(_ category: Category) {
        
        if let subCategoriesVC = navigationController.visibleViewController as? SubCategoriesViewController {
            subCategoriesVC.viewModel.updateCategory(with: category)
        } else {
            startSubCategories(with: category)
        }
    }
    
    func startSearch() {
        debugPrint("Start Search started")
    }
}

// MARK: Additional behaviour
extension CategoriesCoordinator {
    
    /// After pop animation is done etc..
    func didFinish() {
        (parentCoordinator as? TabBarCoordinator)?.childDidFinish(self)
    }
}
