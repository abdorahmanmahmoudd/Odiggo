//
//  SubCategoriesViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 21/01/2021.
//

import Foundation
import RxSwift

final class SubCategoriesViewModel: BaseStateController {
    
    private let apiClient: CategoriesRepository
    
    private(set) var selectedCategory: Category
    
    private var subCategories: [Category] = []
    
    private var totalItems: Int = 0
    
    private var pageNumber: Int = 1
    
    private let disposeBag = DisposeBag()
    
    init(_ apiClient: CategoriesRepository, category: Category) {
        self.apiClient = apiClient
        self.selectedCategory = category
        super.init()
    }
}

// MARK: APIs
extension SubCategoriesViewModel {
    
    func fetchSubCategories(_ pageNumber: Int = 1, isRefreshing: Bool = false, isFetchingNextPage: Bool = false) {
        
        /// If not refreshing show loading indicator
        if !isRefreshing && !isFetchingNextPage {
            loadingState()
        }
        
        apiClient.fetchSubCategories(page: pageNumber,
                                     categoryId: "\(selectedCategory.id)").subscribe(onSuccess: { [weak self] response in
            
            guard let self = self, let categories = response?.data else {
                return
            }
            /// If refreshing, remove the old content
            if isRefreshing {
                self.subCategories.removeAll()
            }
            self.subCategories.append(contentsOf: categories)
            
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
        fetchSubCategories(pageNumber, isFetchingNextPage: true)
    }

    /// Refresh the content
    func refreshCategories() {
        pageNumber = 1
        fetchSubCategories(pageNumber, isRefreshing: true)
    }
    
    func updateCategory(with category: Category) {
        self.selectedCategory = category
        refreshCategories()
    }
     
}

// MARK: Datasource
extension SubCategoriesViewModel {
    
    func numberOfRows() -> Int {
        return subCategories.count
    }
    
    func item(at indexPath: IndexPath) -> Category? {
        return subCategories[safe: indexPath.row]
    }
    
    func isEmpty() -> Bool {
        return subCategories.count == 0
    }
    
    /// Returns whether you should get the next page or not
    func shouldGetNextPage(withCellIndex index: Int) -> Bool{
        
        /// if reached the last cell && not reached the total number of items then reload next page
        if index == subCategories.count - 4 {
            if totalItems > subCategories.count {
                return true
            }
        }
        return false
    }
    
    func sectionTitle() -> String {
        return selectedCategory.name ?? ""
    }
}
