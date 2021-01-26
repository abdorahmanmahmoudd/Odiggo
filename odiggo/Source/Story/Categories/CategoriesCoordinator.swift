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
}

// MARK: Additional behaviour
extension CategoriesCoordinator {
    
    /// After pop animation is done etc..
    func didFinish() {
        (parentCoordinator as? TabBarCoordinator)?.childDidFinish(self)
    }
}

// MARK: SubCategories
extension CategoriesCoordinator {
    
    func startSubCategories(with category: Category) {
        
        let subCategoriesVM = SubCategoriesViewModel(api.categoriesRepository, category: category)
        let subCategoriesVC = SubCategoriesViewController.create(payload: subCategoriesVM)
        subCategoriesVC.coordinator = self
        navigationController.pushViewController(subCategoriesVC, animated: true)
    }
    
    func selectSubCategory(_ category: Category) {
        
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
}

// MARK: Search
extension CategoriesCoordinator {
    
    func startSaerch() {
        
        /// Otherwise open a new one
        let searchVM = SearchViewModel(api.categoriesRepository)
        let searchVC = SearchViewController.create(payload: searchVM)
        searchVC.coordinator = self
        navigationController.pushViewController(searchVC, animated: true)
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

// MARK: SearchResult
extension CategoriesCoordinator {
    
    func startSearchResult(with query: String) {
        
        /// Otherwise open a new one
        let resultVM = SearchResultViewModel(api.categoriesRepository, searchQuery: query)
        let resultVC = SearchResultViewController.create(payload: resultVM)
        resultVC.coordinator = self
        navigationController.pushViewController(resultVC, animated: true)
    }
    
    func keywordSelected(_ keyword: String) {
        
        if let searchResultVC = navigationController.visibleViewController as? SearchResultViewController {
            debugPrint("\(searchResultVC) already presented")
            searchResultVC.viewModel.fetchSearchResult(keyword)
            
        } else {
            
            var screenExists = false
            /// Check for an existing screen
            for viewController in navigationController.viewControllers {
                
                if let resultVC = viewController as? SearchResultViewController {
                    
                    resultVC.viewModel.fetchSearchResult(keyword)
                    navigationController.popToViewController(resultVC, animated: true)
                    screenExists = true
                    break
                }
            }
            /// otheriwse start a new screen
            if !screenExists {
                startSearchResult(with: keyword)
            }
        }
    }
}
