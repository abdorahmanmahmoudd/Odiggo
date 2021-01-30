//
//  HomeColorsCollection.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 17/01/2021.
//

import UIKit

struct HomeColorsCollection {

    private static let colors: [UIColor.Colors] = [.pinkishRed, .squash, .denim, .kelleyGreen, .blackThree]
    
    static func getNextColor(indexedBy index: Int) -> UIColor.Colors {
        let colorIndex = index % colors.count
        return colors[safe: colorIndex] ?? .white
    }
}
