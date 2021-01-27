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
        
    init(_ apiClient: CategoriesRepository, subCategory: Category, parentCategory: Category) {
        self.apiClient = apiClient
        self.subCategory = subCategory
        self.parentCategory = parentCategory
        super.init()
    }
}

// MARK: APIs
extension CategoryResultViewModel {
    
    func fetchCategoryProducts(_ subCategory: Category? = nil, ofParentCategory category: Category? = nil) {
        
        loadingState()
        if let subCategory = subCategory, let category = category {
            self.subCategory = subCategory
            self.parentCategory = category
        }
        
        apiClient.productsCategory("\(self.subCategory.id)").subscribe(onSuccess: { [weak self] response in
            
            guard let self = self, let data = response?.data else {
                debugPrint("\(String(describing: response))")
                return
            }
            debugPrint("\(data.products?.count ?? 0)")
            self.results = data.products ?? []
            self.resultState()
            
        }, onError: { [weak self] error in
            
            self?.errorState(error)
            
        }).disposed(by: disposeBag)
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
}

