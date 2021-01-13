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

}

/// Every repository implementation should subclass the `API`
final class HomeAPI: API, HomeRepository {
    
    /// Endpoints within the Authentication Repository
    enum Endpoint: String {
        case featureCategories
    }
}

// MARK: APIs
extension AuthenticationAPI {
    
//    func fetchHome(email: String, password: String) -> Single<AuthenticationResponse?> {
//
//        let fullUrl = baseUrl(of: .production) + Endpoint.login.rawValue
//        let httpBody = ["email": email, "password": password]
//
//        guard let request = request(fullUrl: fullUrl, method: .post, parameters: httpBody) else {
//            return .error(APIError.invalidRequest)
//        }
//
//        return response(for: request).observeOn(MainScheduler.instance)
//    }
}


