//
//  URLComponents.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 07/01/2021.
//

import Foundation

extension URLComponents {
    
    mutating func setQueryItems(parameters: [String: String?]) {

        self.queryItems = parameters.map({
            return URLQueryItem(name: $0.key, value: $0.value)
        })
    }
}
