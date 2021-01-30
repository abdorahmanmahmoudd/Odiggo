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
    func search(_ query: String) -> Single<SearchResultResponse?>
    func productsCategory(_ id: String) -> Single<CategoryProductsResponse?>
    func productDetails(_ id: String) -> Single<ProductDetailsResponse?>
}

/// Every repository implementation should subclass the `API`
final class CategoriesAPI: API, CategoriesRepository {
    
    /// Endpoints within the Authentication Repository
    enum Endpoint: String {
        case fetchCategories = "/api/customer/categories"
        case fetchSubCategories = "/api/customer/sub-categories/"
        case searchAutoComplete = "/api/customer/product/searchautocomplete"
        case productSearch = "/api/customer/product/search"
        case categoryProducts = "/api/customer/products-by-category/"
        case productById = "/api/customer/product/"
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
    
    func search(_ query: String) -> Single<SearchResultResponse?> {

        let fullUrl = baseUrl(of: .production) + Endpoint.productSearch.rawValue
        let httpBody = ["q": query]

        guard let request = request(fullUrl: fullUrl, method: .get, parameters: httpBody) else {
            return .error(APIError.invalidRequest)
        }

        return response(for: request).observeOn(MainScheduler.instance)
    }
    
    func productsCategory(_ categoryId: String) -> Single<CategoryProductsResponse?> {
        
        let fullUrl = baseUrl(of: .production) + Endpoint.categoryProducts.rawValue + categoryId
        
        guard let request = request(fullUrl: fullUrl, method: .get, parameters: [:]) else {
            return .error(APIError.invalidRequest)
        }
        
        return response(for: request).observeOn(MainScheduler.instance)
    }
    
    func productDetails(_ id: String) -> Single<ProductDetailsResponse?> {
        
        let fullUrl = baseUrl(of: .production) + Endpoint.productById.rawValue + id
        
        guard let request = request(fullUrl: fullUrl, method: .get, parameters: [:]) else {
            return .error(APIError.invalidRequest)
        }
        
        return response(for: request).observeOn(MainScheduler.instance)
    }
}
