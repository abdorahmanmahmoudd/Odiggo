//
//  String.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import Foundation

extension String {
    
    /// A variable that returns the localized value associated to the string as a key
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
