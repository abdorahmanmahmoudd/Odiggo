//
//  API+Error.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import Foundation

// MARK: Custom Errors
enum APIError: Error, LocalizedError {
    
    case decodingError(Swift.Error)
    case networkError(Int)
    case invalidRequest
    case nonHTTPResponse
    case unknown
    case emailNotFound
    
    /// Custom error codes so that we recognize it quicker
    var code: Int {
        switch self {
        case .decodingError:
            return -11001
        case .networkError(let code):
            return code
        case .invalidRequest:
            return -11004
        case .nonHTTPResponse:
            return -11006
        case .unknown:
            return -11007
        case .emailNotFound:
            return -11008
        }
    }
    
    var errorDescription: String? {
        
        let genericMessage = "\("GENERAL_ERROR_DESCRIPTION".localized) \(code)"
        
        switch self {
        
        case .decodingError, .nonHTTPResponse, .unknown, .invalidRequest, .emailNotFound:
            return genericMessage
            
        case let .networkError(code):
            if code == NSURLErrorNotConnectedToInternet {
                return "NO_INTERNET_CONNECTION".localized
            }
            return genericMessage
        }
    }
    
    func mapNetworkError() -> NetworkError {
        
        guard case .networkError(let code) = self else { return .unknown }
        
        switch code {
        case 401, 403:
            return .unauthorized
        case 404:
            return .notFound
        case 400:
            return .badRequest
        default:
            return .unknown
        }
    }
}


// MARK: - Http errors
enum NetworkError: Error {
    case unauthorized
    case invalid
    case notFound
    case notConnected
    case lostConnection
    case unknown
    case badRequest
}
