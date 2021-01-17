//
//  Feedback.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 14/01/2021.
//

import Foundation

struct Feedback: Decodable {
    let customer_id: Int
    let rating: Int?
    let comment: String?
    let crated_at: String?
}
