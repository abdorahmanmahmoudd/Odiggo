//
//  Category.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 14/01/2021.
//

import Foundation

struct Category: Decodable {
    let id: Int
    let name: String?
    let slug: String?
    let description: String?
    let products_count: Int?
    let banner_image: String?
    var sub_categories: [Category]?
}
