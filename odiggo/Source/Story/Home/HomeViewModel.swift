//
//  FeaturedCategoriesViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 14/01/2021.
//

import Foundation
import RxSwift

final class HomeViewModel: BaseStateController {
    
    let apiClient: HomeRepository
    
    var topCategories: [Category] = []
    
    /// Cached Cells Sizes
    private var cellsSizes: [IndexPath: CGSize?] = [:]
    
    private let disposeBag = DisposeBag()
    
    init(_ apiClient: HomeRepository) {
        self.apiClient = apiClient
    }
}

// MARK: APIs
extension HomeViewModel {
    
    func fetchHome() {
        
        loadingState()
        
        apiClient.fetchHome().subscribe(onSuccess: { [weak self] response in
            
            guard let self = self, let data = response?.data else {
                return
            }
            self.topCategories = data.top_categories ?? []
            self.topCategories.append(contentsOf: data.top_categories ?? [])
            self.resultState()
            
        }, onError: { [weak self] error in
            
            self?.errorState(error)

        }).disposed(by: disposeBag)
    }
}

// MARK: Datasource
extension HomeViewModel {
    
    func numberOfItems() -> Int {
        self.topCategories.count
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> Category? {
        return topCategories[safe: indexPath.item]
    }
}

// MARK: Cells sizes
extension HomeViewModel {
    
    func getSize(for indexPath: IndexPath) -> CGSize? {

        guard let size = cellsSizes[indexPath] else {
            return nil
        }
        return size
    }

    func setSize(for indexPath: IndexPath, size: CGSize) {
        cellsSizes[indexPath] = size
    }

    func removeAllSizes() {
        cellsSizes.removeAll()
    }
}
