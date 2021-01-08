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
    
    /// Check if string has any content (white spaces and new line characters are trimmed)
    func hasContent() -> Bool {
        return !(self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)
    }
    
    /// Check if string is a valid email
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }

    /// Check if string is a valid UInt
    func uintValue() -> UInt? {
        return UInt(self.filter("01234567890.".contains))
    }
}
