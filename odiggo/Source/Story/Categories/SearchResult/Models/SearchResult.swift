//
//  SearchResult.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 26/01/2021.
//

import Foundation

struct SearchResult: Decodable {
    let priceRange: PriceRange?
    let origins: [ProductOrigin?]?
    let manufacturers: [ProductManufacturer?]?
    let products: [Product]?
}
