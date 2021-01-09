//
//  AuthenticationRepository.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 07/01/2021.
//

import Foundation
import RxSwift

/// A protocol for each story repository to make it testable and injectable by any implementation
protocol AuthenticationRepository {
    func login(username: String, password: String) -> Single<String?>
    func signup(username: String, email: String, password: String) -> Single<String?>
}

/// Every repository implementation should subclass the `API`
final class AuthenticationAPI: API, AuthenticationRepository {
    
    /// Endpoints within the Authentication Repository
    enum Endpoint: String {
        case login = "/api/customer/login"
        case register = "/api/customer/register"
        case logout = "/api/customer/logout"
        case profile = "/api/customer/profile"
        case forgotPassword = "/api/customer/password/email"
        case passwordUpdate = "/api/customer/password"
    }
}

// MARK: APIs
extension AuthenticationAPI {
    
    func login(username: String, password: String) -> Single<String?> {
        
        let fullUrl = baseUrl(of: .production) + Endpoint.login.rawValue
        let httpBody = ["email": username, "password": password]
        
        guard let request = request(fullUrl: fullUrl, method: .post, parameters: httpBody) else {
            return .error(APIError.invalidRequest)
        }

        return response(for: request).observeOn(MainScheduler.instance)
    }
    
    func signup(username: String, email: String, password: String) -> Single<String?> {
        
        let fullUrl = baseUrl(of: .production) + Endpoint.register.rawValue
        let httpBody = ["username": username, "email": email, "password": password]
        
        guard let request = request(fullUrl: fullUrl, method: .post, parameters: httpBody) else {
            return .error(APIError.invalidRequest)
        }

        return response(for: request).observeOn(MainScheduler.instance)
    }
}

