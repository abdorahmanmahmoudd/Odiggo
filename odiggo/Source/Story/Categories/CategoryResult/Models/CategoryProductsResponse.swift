//
//  CategoryProductsResponse.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 27/01/2021.
//

import Foundation

struct CategoryProductsResponse: Decodable {
    
    let status: Bool?
    let data: CategoryProducts?
    let message: String?
}
