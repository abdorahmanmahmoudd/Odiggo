//
//  HomeViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 14/01/2021.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        styleNavigationItem()
        
        configureViews()
    }
    
    private func styleNavigationItem() {
        
    }
    
    private func configureViews() {
        
    }
}

// MARK: Injectable
extension HomeViewController: Injectable {
    
    typealias Payload = HomeViewModel
    
    func inject(payload: Payload) {
        viewModel = payload
    }

    func assertInjection() {
        assert(viewModel != nil)
    }
}
