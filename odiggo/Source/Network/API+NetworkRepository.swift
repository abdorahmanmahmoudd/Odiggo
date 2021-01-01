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
    
}

// MARK: - API shared client
class API: NetworkRepository {

    /// URLs
    enum URLEnvironment {
        case production
    }
    
    /// CachePolicy
    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalCacheData
    }
    
    /// Shared `URLSession`
    let sharedSession = URLSession.shared
    
    /// Returns the url of the given type
    ///
    /// - Parameter env: the base URL envrionment
    /// - Returns: the url
    func urlOfType(_ environment: URLEnvironment) -> String {
        
        switch environment {
        case .production:
            return "https://www.odiggo.com/"
        }
    }
}

// MARK: - API+NetworkRepository
extension API {

}

// MARK: - API+Response
extension API {
      
    /// Shared generic URL request function.
    func response<T>(for request: URL) -> Single<T> where T: Decodable {
        
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
