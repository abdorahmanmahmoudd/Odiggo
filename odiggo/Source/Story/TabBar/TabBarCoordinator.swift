//
//  TabbarCoordinator.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 13/01/2021.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var api: NetworkRepository
    
    init(_ navigationController: UINavigationController, _ apiClient: NetworkRepository) {
        self.navigationController = navigationController
        self.api = apiClient
    }
    
    func start() {
        
        let tabBarController = UITabBarController()
        
        let homeNavC = UINavigationController()
        homeNavC.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        let homeCoordinator = HomeCoordinator(homeNavC, api)
        
        let categoriesNavC = UINavigationController()
        categoriesNavC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        let categoriesCoordinator = HomeCoordinator(categoriesNavC, api)
        
        let cartNavC = UINavigationController()
        cartNavC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        let cartCoordinator = HomeCoordinator(cartNavC, api)
        
        let moreNavC = UINavigationController()
        moreNavC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)
        let moreCoordinator = HomeCoordinator(moreNavC, api)
        
        tabBarController.viewControllers = [homeNavC,
                                            categoriesNavC,
                                            cartNavC,
                                            moreNavC]
        
        tabBarController.modalPresentationStyle = .fullScreen
        navigationController.present(tabBarController, animated: true, completion: nil)
        
        homeCoordinator.start()
        categoriesCoordinator.start()
        cartCoordinator.start()
        moreCoordinator.start()
        
        addChildCoordinator(homeCoordinator)
        addChildCoordinator(categoriesCoordinator)
        addChildCoordinator(cartCoordinator)
        addChildCoordinator(moreCoordinator)
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
