//
//  CategoriesViewController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 17/01/2021.
//

import UIKit

final class CategoriesViewController: BaseViewController {
    
    private var viewModel: CategoriesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        styleNavigationItem()
    }
    
    private func styleNavigationItem() {
        let searchBtn = UIBarButtonItem.customBarButtonItem(image: UIImage(named: "searchBtn.icon"),
                                                            title: nil, selector: nil, target: nil)
        let addYourCarBtn = UIBarButtonItem.customBarButtonItem(image: UIImage(named: "addCar.icon"),
                                                                title: nil, selector: nil, target: nil)
        navigationItemStyle = NavigationItemStyle.homePageStyle(items: [addYourCarBtn, searchBtn])
    }

}

// MARK: Injectable
extension CategoriesViewController: Injectable {
    
    typealias Payload = CategoriesViewModel
    
    func inject(payload: Payload) {
        viewModel = payload
    }

    func assertInjection() {
        assert(viewModel != nil)
    }
}
