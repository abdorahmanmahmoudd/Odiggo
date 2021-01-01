//
//  Coordinator.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import UIKit

// MARK: Protocol that all our coordinators will conform to.
protocol Coordinator: class {

    /// Navigation controller of the story
    var navigationController: UINavigationController { get set }

    /// Childs coordinators
    var childCoordinators: [Coordinator] { get set }
    
    /// Mandatory start method
    func start()
}

// MARK: Default implementation to manage `childCoordinators`
extension Coordinator {

    func addChildCoordinator(_ coordinator: Coordinator) {
        if !childCoordinators.contains(where: { $0 === coordinator }) {
            childCoordinators.append(coordinator)
        }
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
