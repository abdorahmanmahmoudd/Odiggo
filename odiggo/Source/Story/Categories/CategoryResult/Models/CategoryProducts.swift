//
//  CategoryProducts.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 27/01/2021.
//

import Foundation

struct CategoryProducts: Decodable {
    let selections: Selection?
    let products: [Product]?
}
