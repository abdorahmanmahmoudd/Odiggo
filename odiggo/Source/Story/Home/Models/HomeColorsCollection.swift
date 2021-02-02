//
//  HomeColorsCollection.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 17/01/2021.
//

import UIKit

struct HomeColorsCollection {
    
    private static var texts = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in",
                                "Lorem ipsum dolor s"]
    
    private static let colors: [UIColor.Colors] = [.pinkishRed, .squash, .denim, .kelleyGreen, .blackThree]
    
    static func getNextColor(indexedBy index: Int) -> UIColor.Colors {
        let colorIndex = index % colors.count
        return colors[safe: colorIndex] ?? .white
    }
    
    static func getDescription(_ index: Int) -> String {
        let textIndex = index % texts.count
        return texts[safe: textIndex] ?? ""
    }
}
