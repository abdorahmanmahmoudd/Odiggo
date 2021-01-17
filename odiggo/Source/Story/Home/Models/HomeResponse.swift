//
//  HomeResponse.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 14/01/2021.
//

import Foundation

struct HomeResponse: Decodable {
    let status: Bool?
    let message: String?
    let data: HomeData?
}

struct HomeData: Decodable {
    let cart_sum: Int?
    let message: String?
    var top_categories: [Category]?
    var most_selling: [Product]?
}


