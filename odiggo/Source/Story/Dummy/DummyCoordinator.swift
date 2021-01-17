//
//  DummyCoordinator.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 17/01/2021.
//

import UIKit

final class DummyCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: Coordinator?
    
    var api: NetworkRepository
    
    init(_ navigationController: UINavigationController, _ api: NetworkRepository) {
        self.navigationController = navigationController
        self.api = api
    }
    
    func start() {
        
        let dummyVC = DummyViewController.init()
        dummyVC.coordinator = self
        parentCoordinator?.addChildCoordinator(self)
        navigationController.setViewControllers([dummyVC], animated: false)
    }
}
