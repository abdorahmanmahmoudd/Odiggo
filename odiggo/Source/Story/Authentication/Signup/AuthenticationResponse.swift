//
//  SignupResponse.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 09/01/2021.
//

import Foundation

struct AuthenticationResponse: Decodable {
    let token: String?
    let name: String?
    let status: Bool?
}
