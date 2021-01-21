//
//  CategoriesResponse.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 20/01/2021.
//

import Foundation

struct CategoriesResponse: Decodable {
    
    let status: Bool?
    let data: [Category]?
    let message: String?
    let pagination: Pagination?
}


