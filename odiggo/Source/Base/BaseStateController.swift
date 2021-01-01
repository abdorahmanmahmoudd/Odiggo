//
//  BaseStateController.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 01/01/2021.
//

import Foundation

/// A way of reacting to the ViewModel state changes.
class BaseStateController {
    
    // An enum to keep track of the current state of our ViewModels and it's requests
    enum State: Equatable {
        /// Start state
        case initial
        /// Loading and reloading (inactivity)
        case loading
        /// Pull to refresh
        case refreshing
        /// Error state
        case error(error: Error?)
        /// Result state
        case result
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial): return true
            case (.loading, .loading): return true
            case (.refreshing, .refreshing): return true
            case (.error, .error): return true
            case (.result, .result): return true
            default: return false
            }
        }
    }
    
    private(set) var state: State = .initial {
        didSet {
            refreshState()
        }
    }
    
    /// Callback which can be used to refresh the state
    var refreshState: () -> Void = {}
    
    func initialState() {
        state = .initial
    }
    
    func loadingState() {
        state = .loading
    }
    
    func errorState(_ error: Error?) {
        state = .error(error: error)
    }
    
    func resultState() {
        state = .result
    }
    
    func refreshingState() {
        state = .refreshing
    }
}
