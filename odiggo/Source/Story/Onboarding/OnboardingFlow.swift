//
//  OnboardingFlow.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 02/01/2021.
//

import UIKit

typealias OnboardingScreenContent = (title: String?, subtitle: String?, icon: String?)

/// Note: Order is important to detemine the flow pages order
enum OnboardingFlow: CaseIterable {
    
    /// Onboarding screens
    case welcome
    case buyAndFix
    case findProduct
    case getStarted
    
    /// Screen view type
    var view: UIView.Type {
        
        switch self {
        case .welcome:
            return WelcomeView.self
            
        case .buyAndFix, .findProduct:
            return OnboardingView.self
        
        case .getStarted:
            return GetStartedView.self
        }
    }
    
    /// Content of onboarding screen
    var data: OnboardingScreenContent {
        
        switch self {
        case .welcome:
            return (nil, "WELCOME_SUBTITLE".localized, "welcome")
            
        case .buyAndFix:
            return ("BUY_AND_FIX".localized, "ONBOARDING_SUBTITLE".localized, "buyAndFix")
            
        case .findProduct:
            return ("FIND_PRODUCT".localized, "ONBOARDING_SUBTITLE".localized, "buyAndFix")
        
        case .getStarted:
            return ("ADD_YOUR_CAR".localized, "ONBOARDING_SUBTITLE".localized, "buyAndFix")
        }
    }
}

