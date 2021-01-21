//
//  Pagination.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 20/01/2021.
//

import Foundation

struct Pagination: Decodable {
    let total: Int?
    let per_page: Int?
    let current_page: Int?
    let last_page: Int?
}
