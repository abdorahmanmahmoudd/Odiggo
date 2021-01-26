//
//  TabbarCoordinator.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 13/01/2021.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var tabbarController: TabbarViewController?
    
    var childCoordinators: [Coordinator] = []
    
    var api: NetworkRepository
    
    init(_ navigationController: UINavigationController, _ apiClient: NetworkRepository) {
        self.navigationController = navigationController
        self.api = apiClient
    }
    
    func start() {
        
        self.tabbarController = TabbarViewController.loadFromStoryboard()
        
        let homeNavC = UINavigationController()
        homeNavC.tabBarItem = UITabBarItem.odiggoItem(ofType: .home)
        let homeCoordinator = HomeCoordinator(homeNavC, api)
        homeCoordinator.parentCoordinator = self
        
        let categoriesNavC = UINavigationController()
        categoriesNavC.tabBarItem = UITabBarItem.odiggoItem(ofType: .categories)
        let categoriesCoordinator = CategoriesCoordinator(categoriesNavC, api)
        categoriesCoordinator.parentCoordinator = self
        
        let cartNavC = UINavigationController()
        cartNavC.tabBarItem = UITabBarItem.odiggoItem(ofType: .cart)
        let cartCoordinator = DummyCoordinator(cartNavC, api)
        cartCoordinator.parentCoordinator = self
        
        let moreNavC = UINavigationController()
        moreNavC.tabBarItem = UITabBarItem.odiggoItem(ofType: .more)
        let moreCoordinator = DummyCoordinator(moreNavC, api)
        moreCoordinator.parentCoordinator = self
        
        tabbarController?.viewControllers = [homeNavC,
                                            categoriesNavC,
                                            cartNavC,
                                            moreNavC]
                
        tabbarController?.modalPresentationStyle = .fullScreen
        navigationController.present(tabbarController ?? UITabBarController(), animated: false, completion: nil)
        
        homeCoordinator.start()
        categoriesCoordinator.start()
        cartCoordinator.start()
        moreCoordinator.start()
    }
}

// MARK: Additional behaviour
extension TabBarCoordinator {
    
    func childDidFinish(_ child: Coordinator) {
        
        removeChildCoordinator(child)
        
        switch child.self {
        default:
            debugPrint("childDidFinish not handling \(child)")
        }
    }
}

// MARK: Home-related
extension TabBarCoordinator {
    
    /// Helper method to find `CategoriesCoordinator` and the index.
    private func getCategoriesCoordinator() -> (CategoriesCoordinator?, Int?) {
        
        if let index = childCoordinators.firstIndex(where: { (coordinator) -> Bool in
            return coordinator as? CategoriesCoordinator != nil
        }) {
            let categoriesCoordinator = childCoordinators[index] as? CategoriesCoordinator
            return (categoriesCoordinator, index)
        }
        return (nil, nil)
    }
    
    func didSelectTopCategory(_ category: Category) {
        
        let (cooridantor, index) = getCategoriesCoordinator()
        guard let unwrappedCoordinator = cooridantor,
              let unwrappedIndex = index else {
            debugPrint("Coudln't find Categories Coordinator")
            return
        }
        
        unwrappedCoordinator.selectSubCategory(category)
        tabbarController?.selectedIndex = unwrappedIndex
    }
    
    func openSearch() {
        
        let (cooridantor, index) = getCategoriesCoordinator()
        guard let unwrappedCoordinator = cooridantor,
              let unwrappedIndex = index else {
            debugPrint("Coudln't find Categories Coordinator")
            return
        }
        
        unwrappedCoordinator.gotoSearch()
        tabbarController?.selectedIndex = unwrappedIndex
    }
}
