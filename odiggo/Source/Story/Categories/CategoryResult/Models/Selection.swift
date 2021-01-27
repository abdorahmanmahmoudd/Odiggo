//
//  Selection.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 27/01/2021.
//

import Foundation

struct Selection: Decodable {
    let manufacturers: [ProductManufacturer]?
    let origins: [ProductOrigin]?
    let price: PriceRange?
}
