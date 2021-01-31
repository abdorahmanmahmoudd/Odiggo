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
    func priceLabeled(_ priceSize: UIFont.FontSize = .medium, _ labelSize: UIFont.FontSize = .small,
                      with priceColor: UIColor.Colors = .brownishGrey) -> NSAttributedString {
        
        let priceAttributes = [.font: UIFont.font(.primaryBold, priceSize),
                               .foregroundColor: UIColor.color(color: priceColor)] as [NSAttributedString.Key: Any]
        let mutableAttributedPrice = NSMutableAttributedString(string: self, attributes: priceAttributes)
        
        let currentString = "CURRENCY_Abb".localized
        let currencyAttributes = [.font: UIFont.font(.primaryMedium, labelSize),
                                  .foregroundColor: UIColor.color(color: .brownishGrey)] as [NSAttributedString.Key: Any]
        let attributedCurrency = NSAttributedString(string: currentString, attributes: currencyAttributes)
        
        mutableAttributedPrice.append(attributedCurrency)
        
        return mutableAttributedPrice
    }
    
    /// A helper method to get a string underlined
    func underlinedText() -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue

        return NSAttributedString(string: self, attributes: attributes)
    }
    
    // MARK: - Helper methods to convert HTML string to NSAttributed String.
    func htmlAttributedString() -> NSAttributedString {
        
        let data = Data(self.utf8)
        let attributedString = try? NSAttributedString(data: data,
                                                       options: [.documentType: NSAttributedString.DocumentType.html],
                                                       documentAttributes: nil)
        return attributedString ?? NSAttributedString(string: self)
    }
    
    
    var htmlToAttributedString: NSAttributedString {

        let attributeKey = NSAttributedString.DocumentAttributeKey.self
        if let options = [
            attributeKey.documentType.rawValue: NSAttributedString.DocumentType.html,
            attributeKey.characterEncoding: String.Encoding.utf8.rawValue,
        ] as? [NSAttributedString.DocumentReadingOptionKey: Any] {

            guard let htmlData = data(using: String.Encoding.utf8) else {
                return NSAttributedString(string: self)
            }

            if let attributedString = try? NSAttributedString(data: htmlData, options: options, documentAttributes: nil) {
                return attributedString
            }
        }
        return NSAttributedString(string: self)
    }

    func htmlToAttributedString(withFont font: UIFont?, andColor color: UIColor?) -> NSAttributedString? {

        let attributeKey = NSAttributedString.DocumentAttributeKey.self
        if let options = [
            attributeKey.documentType.rawValue: NSAttributedString.DocumentType.html,
            attributeKey.characterEncoding: String.Encoding.utf8.rawValue,
        ] as? [NSAttributedString.DocumentReadingOptionKey: Any] {

            guard let htmlData = data(using: String.Encoding.utf8) else {
                return nil
            }

            if let attributedString = try? NSMutableAttributedString(data: htmlData, options: options, documentAttributes: nil) {
                var attributes = attributedString.attributes(at: 0, effectiveRange: nil)
                attributes[NSAttributedString.Key.font] = font
                attributes[NSAttributedString.Key.foregroundColor] = color
                attributes[NSAttributedString.Key.strokeColor] = color
                attributedString.setAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
                return attributedString
            }
        }
        return nil
    }
}
