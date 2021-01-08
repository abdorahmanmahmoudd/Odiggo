//
//  UserManager.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 08/01/2021.
//

import Foundation

final class UserManager {
    
    static let shared = UserManager()
    
    let defaults = UserDefaults.standard
    
    private init() { }
    
}

// MARK: User Defaults
extension UserManager {
    
    var onboardingCompleted: Bool {
        get {
            return UserManager.shared.defaults.bool(forKey: Constants.UserManager.onboardedKey)
        }
        set {
            UserManager.shared.defaults.set(newValue, forKey: Constants.UserManager.onboardedKey)
        }
    }
    
}
