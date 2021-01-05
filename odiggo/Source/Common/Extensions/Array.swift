//
//  Array.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 05/01/2021.
//

import Foundation

extension Array {
 
    /// Returns value from given index. If out of bounds, return nil
     subscript (safe index: Int) -> Element? {
         return index < count && index >= 0 ? self[index] : nil
     }
}

