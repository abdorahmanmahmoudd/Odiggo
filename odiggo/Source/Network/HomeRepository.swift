//
//  HomeRepository.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 14/01/2021.
//

import Foundation
import RxSwift

/// A protocol for each story repository to make it testable and injectable by any implementation
protocol HomeRepository {
    func fetchHome() -> Single<HomeResponse?>
}

/// Every repository implementation should subclass the `API`
final class HomeAPI: API, HomeRepository {
    
    /// Endpoints within the Authentication Repository
    enum Endpoint: String {
        case home = "/api/customer/home"
    }
}

// MARK: APIs
extension HomeAPI {
    
    func fetchHome() -> Single<HomeResponse?> {

        let fullUrl = baseUrl(of: .production) + Endpoint.home.rawValue

        guard let request = request(fullUrl: fullUrl, method: .get, parameters: [:]) else {
            return .error(APIError.invalidRequest)
        }

        return response(for: request).observeOn(MainScheduler.instance)
    }
}


