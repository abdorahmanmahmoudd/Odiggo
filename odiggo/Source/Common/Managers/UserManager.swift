//
//  UserManager.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 08/01/2021.
//

import Foundation
import RxCocoa
import RxSwift

enum UserState {
    case loggedIn
    case loggedOut
    case unknown
}

// Note: A User authentication and information class that utilizes the authentication repository.
final class UserManager {
    
    private let defaults = UserDefaults.standard
    
    /// A state to keep track of the state of the user
    private(set) var userState = BehaviorRelay<UserState>(value: .unknown)
    
    /// Bool to keep track of our refresh
    private var refreshing: Bool = false
    
    /// Our API
    private let api: NetworkRepository

    /// Rx
    private let disposeBag = DisposeBag()

    /// The keychain instance that we want to use to perform transactions
    private let keychain: Keychain

    /**
     Initialize the UserManager
     - note: Will use a default keychain if non is provided
     */
    init(api: NetworkRepository, keychain: Keychain = Keychain(configuration: .userAuthentication)) {
        self.api = api
        self.keychain = keychain

        bindObservables()

        if isAuthenticated {
            userState.accept(.loggedIn)
        } else {
            userState.accept(.loggedOut)
        }
    }
}

// MARK: User Defaults
extension UserManager {
    
    var onboardingCompleted: Bool {
        get {
            return defaults.bool(forKey: Constants.UserManager.onboardingCompleted)
        }
        set {
            defaults.set(newValue, forKey: Constants.UserManager.onboardingCompleted)
        }
    }
    
    var preferredLanguage: String {
        get {
            return defaults.value(forKey: Constants.UserManager.preferredLanguage) as? String ?? "en"
        }
        set {
            defaults.set(newValue, forKey: Constants.UserManager.preferredLanguage)
        }
    }
}

// MARK: - Observables
extension UserManager {

    func bindObservables() {
        
        userState
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                
                debugPrint("\(self) -> new user state \(state)")
                
            }).disposed(by: disposeBag)
    }
}

// MARK: - Authentication Requests
extension UserManager {

    func login(email: String, password: String) -> Single<AuthenticationResponse?> {

        return api.authenticationRepository.login(email: email, password: password).do(onSuccess: { [weak self] response in
            
            guard let self = self else {
                return
            }
            
            if let response = response {
                self.setAuthenticationResponse(with: response)
                self.userState.accept(.loggedIn)
                
            } else {
                self.userState.accept(.loggedOut)
            }
            
        }, onError: { [weak self] error in
            self?.userState.accept(.loggedOut)
        })
    }
    
    func signup(username: String, email: String, password: String) -> Single<AuthenticationResponse?> {

        return api.authenticationRepository.signup(username: username, email: email, password: password).do(onSuccess: { [weak self] response in
            
            guard let self = self else {
                return
            }
            
            if let response = response {
                self.setAuthenticationResponse(with: response)
                self.userState.accept(.loggedIn)
                
            } else {
                self.userState.accept(.loggedOut)
            }
            
        }, onError: { [weak self] error in
            self?.userState.accept(.loggedOut)
        })
    }
}

// MARK: - Logging a user out
extension UserManager {

    func logout() {
        resetAuthentication()
        userState.accept(.loggedOut)
    }
}

// MARK: - Authentication
extension UserManager {
    
    /// Token for Authentication
    var accessToken: String? {

        /// Check if we have data
        guard let data = keychain.data(for: Constants.UserManager.accessToken) else {
            return nil
        }

        /// Return it
        return String(data: data, encoding: .utf8)
    }

    var isAuthenticated: Bool {

        if let token = accessToken, !token.isEmpty {
            return true
        }

        return false
    }

    /// Set our response and store this
    func setAuthenticationResponse(with authenticationResponse: AuthenticationResponse) {

        // Reset our authentication
        resetAuthentication()

        guard let token = authenticationResponse.token else {
            debugPrint("Token is nil")
            return
        }
        // Store the new token
        store(value: token, key: Constants.UserManager.accessToken)
    }

    /// To reset our authentication
    func resetAuthentication() {

        /// Reset our Keychain
        reset()
    }

    /**
     Stores a server retrieved token in the users keychain
     - parameter token: The token we want to store into the keychains
     - returns: An bool if the transaction was successfull
     */
    @discardableResult
    private func store(value: String, key: String) -> Bool {
        return keychain.set(value, for: key)
    }

    /**
     Resets all the data in the keychain
     */
    @discardableResult
    private func reset() -> Bool {
        return keychain.reset()
    }
}
