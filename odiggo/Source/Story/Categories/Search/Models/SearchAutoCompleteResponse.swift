//
//  SearchAutoCompleteResponse.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 23/01/2021.
//

import Foundation

struct SearchAutoCompleteResponse: Decodable {

    let status: Bool?
    let data: AutoCompleteData?
    let message: String?
}

struct AutoCompleteData: Decodable {
    let data: [String]?
}
