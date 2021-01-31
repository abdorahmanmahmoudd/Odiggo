//
//  CategoryResultViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 27/01/2021.
//

import Foundation
import RxSwift

final class CategoryResultViewModel: BaseStateController {
    
    private let apiClient: CategoriesRepository
    private let disposeBag = DisposeBag()
    private var results: [Product] = []
    private var subCategory: Category
    private var parentCategory: Category
    private var shouldFetchNextPage = true
    private var pageNumber = 1
        
    init(_ apiClient: CategoriesRepository, subCategory: Category, parentCategory: Category) {
        self.apiClient = apiClient
        self.subCategory = subCategory
        self.parentCategory = parentCategory
        super.init()
    }
}

// MARK: APIs
extension CategoryResultViewModel {
    
    func fetchCategoryProducts(_ subCategory: Category? = nil, ofParentCategory category: Category? = nil,
                               page: Int = 1, isFetchingNextPage: Bool = false) {
        
        if !isFetchingNextPage {
            loadingState()
        }
        
        if let subCategory = subCategory, let category = category {
            self.subCategory = subCategory
            self.parentCategory = category
        }
        
        apiClient.categoryProducts("\(self.subCategory.id)", page: page).subscribe(onSuccess: { [weak self] response in
            
            guard let self = self, let data = response?.data else {
                debugPrint("\(String(describing: response))")
                return
            }
            debugPrint("\(data.products?.count ?? 0)")
            self.results.append(contentsOf: data.products ?? [])
            if data.products?.count == 0 {
                self.shouldFetchNextPage = false
            }
            self.resultState()
            
        }, onError: { [weak self] error in
            
            self?.shouldFetchNextPage = false
            self?.errorState(error)
            
        }).disposed(by: disposeBag)
    }
    
    /// Get next products page
    func getNextPage() {
        pageNumber += 1
        fetchCategoryProducts(page: pageNumber, isFetchingNextPage: true)
    }
}

// MARK: Datasource
extension CategoryResultViewModel {
    
    func numerOfRows() -> Int {
        return results.count
    }
    
    func item(for index: IndexPath) -> Product? {
        return results[safe: index.row]
    }
    
    func isEmpty() -> Bool {
        return results.isEmpty
    }
    
    func categoryName() -> String {
        return parentCategory.name ?? ""
    }
    
    func subCategoryName() -> String {
        return  subCategory.name ?? ""
    }
    
    /// Returns whether you should get the next page or not
    func shouldGetNextPage(withCellIndex index: Int) -> Bool{
        
        /// if reached the last cell && not reached the total number of items then reload next page
        if index == results.count - 4 {
            return shouldFetchNextPage
        }
        return false
    }
}

