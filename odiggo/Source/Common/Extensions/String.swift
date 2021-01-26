//
//  String.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import UIKit

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
    
    func isValidPassword() -> Bool {
        let passwordRegEx = "^[^\";'\\\\|]{6,16}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)

        return passwordPred.evaluate(with: self)
    }

    /// Check if string is a valid UInt
    func uintValue() -> UInt? {
        return UInt(self.filter("01234567890.".contains))
    }
    
    /// calculate height for string
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    /// calculate width for string
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    /// A helper method to get a string in the pricing format -> `price`,Currency
    func priceLabeled() -> NSAttributedString {
        
        let priceAttributes = [.font: UIFont.font(.primaryBold, 17),
                               .foregroundColor: UIColor.color(color: .brownishGrey)] as [NSAttributedString.Key: Any]
        let mutableAttributedPrice = NSMutableAttributedString(string: self, attributes: priceAttributes)
        
        let currentString = "CURRENCY_Abb".localized
        let currencyAttributes = [.font: UIFont.font(.primaryMedium, .small),
                                  .foregroundColor: UIColor.color(color: .brownishGrey)] as [NSAttributedString.Key: Any]
        let attributedCurrency = NSAttributedString(string: currentString, attributes: currencyAttributes)
        
        mutableAttributedPrice.append(attributedCurrency)
        
        return mutableAttributedPrice
    }
}
