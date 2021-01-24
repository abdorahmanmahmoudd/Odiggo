//
//  CategoriesRepository.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 20/01/2021.
//

import Foundation
import RxSwift

/// A protocol for each story repository to make it testable and injectable by any implementation
protocol CategoriesRepository {
    func fetchCategories(page: Int) -> Single<CategoriesResponse?>
    func fetchSubCategories(page: Int, categoryId: String) -> Single<CategoriesResponse?>
    func fetchKeywords(_ term: String) -> Single<SearchAutoCompleteResponse?>
}

/// Every repository implementation should subclass the `API`
final class CategoriesAPI: API, CategoriesRepository {
    
    /// Endpoints within the Authentication Repository
    enum Endpoint: String {
        case fetchCategories = "/api/customer/categories"
        case fetchSubCategories = "/api/customer/sub-categories/"
        case searchAutoComplete = "/api/customer/product/searchautocomplete"
    }
}

// MARK: APIs
extension CategoriesAPI {
    
    func fetchCategories(page: Int) -> Single<CategoriesResponse?> {

        let fullUrl = baseUrl(of: .production) + Endpoint.fetchCategories.rawValue
        let httpBody = ["page": "\(page)"]

        guard let request = request(fullUrl: fullUrl, method: .get, parameters: httpBody) else {
            return .error(APIError.invalidRequest)
        }

        return response(for: request).observeOn(MainScheduler.instance)
    }
    
    func fetchSubCategories(page: Int, categoryId: String) -> Single<CategoriesResponse?> {

        let fullUrl = baseUrl(of: .production) + Endpoint.fetchSubCategories.rawValue + categoryId
        let httpBody = ["page": "\(page)"]

        guard let request = request(fullUrl: fullUrl, method: .get, parameters: httpBody) else {
            return .error(APIError.invalidRequest)
        }

        return response(for: request).observeOn(MainScheduler.instance)
    }
    
    func fetchKeywords(_ term: String) -> Single<SearchAutoCompleteResponse?> {

        let fullUrl = baseUrl(of: .production) + Endpoint.searchAutoComplete.rawValue
        let httpBody = ["term": term]

        guard let request = request(fullUrl: fullUrl, method: .get, parameters: httpBody) else {
            return .error(APIError.invalidRequest)
        }

        return response(for: request).observeOn(MainScheduler.instance)
    }
}
