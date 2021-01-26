//
//  SearchResultResponse.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 26/01/2021.
//

import Foundation

struct SearchResultResponse: Decodable {
    let status: Bool?
    let data: SearchResult?
    let message: String?
}
