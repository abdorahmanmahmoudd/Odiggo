//
//  UITextField.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 07/01/2021.
//

import UIKit

extension UITextField {
    
    func toggleSecureEntry() {
        let wasFirstResponder = isFirstResponder
        
        if wasFirstResponder {
            resignFirstResponder()
        }
        
        isSecureTextEntry.toggle()
        
        if wasFirstResponder {
            becomeFirstResponder()
        }
    }
}
