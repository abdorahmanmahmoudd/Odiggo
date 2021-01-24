//
//  CategoriesViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 17/01/2021.
//

import Foundation
import RxSwift

final class CategoriesViewModel: BaseStateController {
    
    private let apiClient: CategoriesRepository
    
    private var categories: [Category] = []
    
    private var totalItems: Int = 0
    
    private var pageNumber: Int = 1
    
    private let disposeBag = DisposeBag()
    
    init(_ apiClient: CategoriesRepository) {
        self.apiClient = apiClient
        super.init()
    }
}

// MARK: APIs
extension CategoriesViewModel {
    
    func fetchCategories(_ pageNumber: Int = 1, isRefreshing: Bool = false, isFetchingNextPage: Bool = false) {
        
        /// If not refreshing show loading indicator
        if !isRefreshing && !isFetchingNextPage {
            loadingState()
        }
        
        apiClient.fetchCategories(page: pageNumber).subscribe(onSuccess: { [weak self] response in
            
            guard let self = self, let categories = response?.data else {
                return
            }
            /// If refreshing, remove the old content
            if isRefreshing {
                self.categories.removeAll()
            }
            self.categories.append(contentsOf: categories)
            
            if let totalItems = response?.pagination?.total {
                self.totalItems = totalItems
            }
            
            self.resultState()
            
        }, onError: { [weak self] error in
            
            self?.errorState(error)
            
        }).disposed(by: disposeBag)
    }
    
    /// Get next products page
    func getNextPage() {
        pageNumber += 1
        fetchCategories(pageNumber, isFetchingNextPage: true)
    }

    /// Refresh the content
    func refreshCategories() {
        pageNumber = 1
        fetchCategories(isRefreshing: true)
    }
     
}

// MARK: Datasource
extension CategoriesViewModel {
    
    func numberOfRows() -> Int {
        return categories.count
    }
    
    func item(at indexPath: IndexPath) -> Category? {
        return categories[safe: indexPath.row]
    }
    
    func isEmpty() -> Bool {
        return categories.count == 0
    }
    
    /// Returns whether you should get the next page or not
    func shouldGetNextPage(withCellIndex index: Int) -> Bool{
        
        /// if reached the last cell && not reached the total number of items then reload next page
        if index == categories.count - 4 {
            if totalItems > categories.count {
                return true
            }
        }
        return false
    }
}
