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
        navigationController.pushViewController(subCategoriesVC, animated: true)
    }
    
    func startSaerch() {
        
        /// Otherwise open a new one
        let searchVM = SearchViewModel(api.categoriesRepository)
        let searchVC = SearchViewController.create(payload: searchVM)
        searchVC.coordinator = self
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    func selectCategory(_ category: Category) {
        
        if let subCategoriesVC = navigationController.visibleViewController as? SubCategoriesViewController {
            subCategoriesVC.viewModel.updateCategory(with: category)
            
        } else {
            
            var screenExists = false
            /// Check for an existing screen
            for viewController in navigationController.viewControllers {
                if viewController is SubCategoriesViewController {
                    (viewController as? SubCategoriesViewController)?.viewModel.updateCategory(with: category)
                    navigationController.popToViewController(viewController, animated: true)
                    screenExists = true
                    break
                }
            }
            
            /// otheriwse start a new screen
            if !screenExists {
                startSubCategories(with: category)
            }
        }
    }
    
    func gotoSearch() {
        
        if let searchVC = navigationController.visibleViewController as? SearchViewController {
            debugPrint("\(searchVC) already presented")
            
        } else {
            
            var screenExists = false
            /// Check for an existing screen
            for viewController in navigationController.viewControllers {
                if viewController is SearchViewController {
                    navigationController.popToViewController(viewController, animated: true)
                    screenExists = true
                    break
                }
            }
            
            /// otheriwse start a new screen
            if !screenExists {
                startSaerch()
            }
        }
    }
}

// MARK: Additional behaviour
extension CategoriesCoordinator {
    
    /// After pop animation is done etc..
    func didFinish() {
        (parentCoordinator as? TabBarCoordinator)?.childDidFinish(self)
    }
}
