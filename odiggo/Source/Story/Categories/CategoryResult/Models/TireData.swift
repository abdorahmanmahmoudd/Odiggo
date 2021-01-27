//
//  TireData.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 27/01/2021.
//

import Foundation

struct TireData: Decodable {
    let tireWidth: [DataRecord]?
    let wheelDiameter: [DataRecord]?
    let aspectRatio: [DataRecord]?
}
