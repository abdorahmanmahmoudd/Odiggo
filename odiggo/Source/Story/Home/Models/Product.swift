//
//  Product.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 14/01/2021.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let product_id: Int
    let oem: String?
    let mpn: String?
    let sku: String?
    let seller: String?
    let name: String?
    let slug: String?
    let stock_quantity: Int?
    let sale_price: Float?
    let offer_price: Float
//    let offer_start: String? /// "2020-01-12 16:39:00"
    
    // TODO: Check with BE, what is the type of offer_end & offer_start
    //    "offer_end": {
    //          "date": "2020-01-01 00:59:00.000000",
    //          "timezone_type": 3,
    //          "timezone": "Africa/Cairo"
    //        },
//    let offer_end: String? /// "2021-02-28 17:39:00"
    let active: Bool?
    let description: String? /// HTML
    var categories: [Category]?
    let manufacturer: String?
    let origin: String?
    let featuredImage: String?
    let image: String?
    var related: [Product]?
    var linked_items: [Product]?
    let average_feedback: Int?
    var feedbacks: [Feedback]?
    let count_feedback: Int?
}
