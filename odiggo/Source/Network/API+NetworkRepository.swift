//
//  API+NetworkRepository.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import Foundation
import RxSwift

/// A protocol to group all of our app repositories so we have single and central dependency for network requests across the app.
protocol NetworkRepository {
    var authenticationRepository: AuthenticationRepository { get }
}

// MARK: - API shared client
class API: NetworkRepository {

    /// Environment types
    enum Environment {
        case production
    }
    
    /// CachePolicy
    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalCacheData
    }
    
    /// Shared `URLSession`
    let sharedSession = URLSession.shared
    
    /// Returns the base URL of the given type
    ///
    /// - Parameter env: the base URL envrionment
    /// - Returns: the URL string
    func baseUrl(of environment: Environment) -> String {
        
        switch environment {
        case .production:
            return "https://www.odiggo.com.eg"
        }
    }
}

// MARK: - API+NetworkRepository
extension API {
    
    var authenticationRepository: AuthenticationRepository {
        return AuthenticationAPI()
    }
}

// MARK: API+Request
extension API {
    
    /// Helper method to construct the URL Request
    func request(fullUrl: String, method: HTTPMethod = .post, parameters: [String: String?] = [:]) -> URLRequest? {
        
        let urlString = fullUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let urlStringUnwrapped = urlString, var urlComponents = URLComponents(string: urlStringUnwrapped) else {
            return nil
        }
        urlComponents.setQueryItems(parameters: parameters)
        
        guard let url  = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = urlComponents.percentEncodedQuery?.data(using: .utf8)
        
//        if let accessToken = accessToken {
//            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        }
        
        return request
    }
}

// MARK: - API+Response
extension API {
      
    /// Helper method to trigger the API call and parse the response
    func response<T>(for request: URLRequest) -> Single<T> where T: Decodable {
        
        return Single<T>.create { (single) -> Disposable in
            
            let task = self.sharedSession.dataTask(with: request) { data, response, error in
                
                // Validate Response
                guard let response = response, let data = data else {
                    single(.error(error ?? API.Error.unknown))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    single(.error(API.Error.nonHTTPResponse))
                    return
                }
                
                guard (200 ..< 300) ~= httpResponse.statusCode, error == nil else {
                    return single(.error(API.Error.networkError(httpResponse.statusCode)))
                }
                
                // Decode data into a model
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let model = try decoder.decode(T.self, from: data)
                    single(.success(model))
                } catch {
                    single(.error(API.Error.decodingError(error)))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
