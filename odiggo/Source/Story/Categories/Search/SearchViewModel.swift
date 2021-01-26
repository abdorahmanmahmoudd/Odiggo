//
//  SearchViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 23/01/2021.
//

import Foundation
import RxSwift

final class SearchViewModel: BaseStateController {
    
    private let apiClient: CategoriesRepository
    private let disposeBag = DisposeBag()
    
    private var keywords: [String] = []
    private var term = String()
    
    private var searchHistory = [String]()
    
    init(_ apiClient: CategoriesRepository) {
        self.apiClient = apiClient
        super.init()
    }
}

// MARK: APIs
extension SearchViewModel {
    
    func fetchKeywords(_ term: String = "") {
        
        loadingState()
        self.term = term

        if !term.isEmpty && term != searchHistory.last {
            self.searchHistory.append(term)
            storeSearchHistory(with: searchHistory)
        }
        
        apiClient.fetchKeywords(self.term).subscribe(onSuccess: { [weak self] response in
            
            guard let self = self, let keywords = response?.data?.data else {
                return
            }
            self.keywords = keywords
            self.resultState()
            
        }, onError: { [weak self] error in
            
            self?.errorState(error)
            
        }).disposed(by: disposeBag)
    }
    
    func fetchSearchHistory() {
        guard let history = storedSearchHistory() else {
            return
        }
        searchHistory = history
        fetchKeywords(searchHistory.last ?? "")
        resultState()
    }
}

// MARK: Keywords Datasource
extension SearchViewModel {
    
    func keyword(for index: IndexPath) -> String? {
        return keywords[safe: index.item]
    }
    
    func numberOfKeywords() -> Int {
        return keywords.count
    }
}

// MARK: Search History Datasource
extension SearchViewModel {
    
    func storeSearchHistory(with history: [String]) {
        do {
            UserDefaults.standard.set(try PropertyListEncoder().encode(history),
                                      forKey: Constants.Search.searchHistoryLocalStorageKey)

        } catch {
            debugPrint("failed to store history with error: \(error.localizedDescription)")
        }
    }

    func storedSearchHistory() -> [String]? {
        do {
            if let data = UserDefaults.standard.object(forKey: Constants.Search.searchHistoryLocalStorageKey) as? Data {
                return try PropertyListDecoder().decode([String].self, from: data)
            }

        } catch {
            debugPrint("Failed while decoding history with error: \(error.localizedDescription)")
        }

        return nil
    }
    
    func removeSearchItem(for index: IndexPath) {
        var reversedList = Array(searchHistory.reversed())
        reversedList.remove(at: index.row)
        searchHistory = Array(reversedList.reversed())
        storeSearchHistory(with: searchHistory)
        resultState()
    }
    
    func numberOfSearchHistoryRecords() -> Int {
        return searchHistory.count
    }
    
    func searchHistory(for indexPath: IndexPath) -> String? {
        return searchHistory.reversed()[safe: indexPath.row]
    }
}
