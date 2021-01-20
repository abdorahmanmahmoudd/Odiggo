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
    
    func didSelectTopCategory(_ category: Category) {
        
        guard let categoriesCoordinatorIndex = childCoordinators.firstIndex(where: { (coordinator) -> Bool in
            return coordinator as? CategoriesCoordinator != nil
        }) else {
            return
        }
        
        let categoriesCoordinator = childCoordinators[categoriesCoordinatorIndex] as? CategoriesCoordinator
        categoriesCoordinator?.selectCategory(category)
        
        tabbarController?.selectedIndex = categoriesCoordinatorIndex
    }
}
