//
//  ProductsCoordinator.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 10/01/2021.
//

import UIKit

final class ProductsCoordinator: Coordinator {
    
    var rootViewController: UIViewController?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: Coordinator?
    
    var api: NetworkRepository
    
    init(_ navigationController: UINavigationController, _ api: NetworkRepository) {
        self.navigationController = navigationController
        self.api = api
    }
    
    func start() {
        
        rootViewController = ProductsViewController.init()
        (rootViewController as? BaseViewController)?.coordinator = self
    }
}

// MARK: Additional behaviour
extension ProductsCoordinator {
    
    /// After pop animation is done etc..
    func didFinish() {
        (parentCoordinator as? AppCoordinator)?.childDidFinish(self)
    }
}

