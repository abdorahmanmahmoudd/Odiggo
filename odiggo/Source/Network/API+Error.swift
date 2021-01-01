//
//  API+Error.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import Foundation

// MARK: API+Error
extension API {
    
    /// Custom local error codes
    enum Error: LocalizedError {

        case decodingError(Swift.Error)
        case networkError(Int)
        case invalidURLHost
        case invalidURLPath
        case nonHTTPResponse
        case unknown
        
        
        // Custom error codes so that we recognize it quicker
        var code: Int {
            switch self {
            case .decodingError:
                return -11001
            case .networkError(let errorCode):
                return errorCode
            case .invalidURLHost:
                return -11004
            case .invalidURLPath:
                return -11005
            case .nonHTTPResponse:
                return -11006
            case .unknown:
                return -11007
            }
        }
        
        var errorDescription: String? {
            
            let genericMessage = "\("GENERAL_ERROR_DESCRIPTION".localized)\(code)"
            
            switch self {
            
            case .decodingError, .nonHTTPResponse, .unknown, .invalidURLHost, .invalidURLPath:
            return genericMessage
            
            case let .networkError(errorCode):
                if errorCode == NSURLErrorNotConnectedToInternet {
                    return "NO_INTERNET_CONNECTION".localized
                }
                return genericMessage
            }
        }
    }
}


