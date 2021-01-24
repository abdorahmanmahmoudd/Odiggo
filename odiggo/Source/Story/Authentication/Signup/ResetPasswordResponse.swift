//
//  ResetPasswordResponse.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 24/01/2021.
//

import Foundation

struct ResetPasswordResponse: Decodable {
    let status: Bool?
    let data: [String]?
    let message: String?
}
