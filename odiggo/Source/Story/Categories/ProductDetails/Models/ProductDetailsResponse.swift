//
//  ProductDetailsResponse.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 28/01/2021.
//

import Foundation

struct ProductDetailsResponse: Decodable {
    let status: Bool?
    let data: Product?
    let message: String?
}
