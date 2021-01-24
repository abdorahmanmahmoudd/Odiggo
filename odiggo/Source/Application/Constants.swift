//
//  Constants.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import UIKit

/// App Global constants
struct Constants {
    
    struct Theme {
        static let homeNavItemLogoHeight: CGFloat = 33
    }
    
    struct Login {
        static let inputsMaxLength = 40
        static let passwordMinimumLength = 9
    }
    
    struct UserManager {
        static let onboardingCompleted = "UserManager.Keys.OnboardingCompleted"
        static let accessToken = "UserManager.Keys.AccessToken"
        static let preferredLanguage = "UserManager.Keys.PreferredLanguage"
        static let firstTimeInstall = "UserManager.Keys.FirstTimeInstall"
    }
    
    struct Search {
        static let searchHistoryLocalStorageKey = "Search.Keys.SearchHistory"
    }
}
