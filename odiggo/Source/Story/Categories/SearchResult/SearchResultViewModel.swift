//
//  SearchResultViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 25/01/2021.
//

import Foundation
import RxSwift

final class SearchResultViewModel: BaseStateController {
    
    private let apiClient: CategoriesRepository
    private let disposeBag = DisposeBag()
    private var results: [Product] = []
    private var searchQuery: String
        
    init(_ apiClient: CategoriesRepository, searchQuery: String) {
        self.apiClient = apiClient
        self.searchQuery = searchQuery
        super.init()
    }
}

// MARK: APIs
extension SearchResultViewModel {
    
    func fetchSearchResult(_ query: String = "") {
        
        loadingState()
        if !query.isEmpty {
            self.searchQuery = query
        }
        
        apiClient.search(searchQuery).subscribe(onSuccess: { [weak self] response in
            
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
extension SearchResultViewModel {
    
    func numerOfRows() -> Int {
        return results.count
    }
    
    func item(for index: IndexPath) -> Product? {
        return results[safe: index.row]
    }
}

