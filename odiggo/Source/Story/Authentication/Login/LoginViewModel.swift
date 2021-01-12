//
//  LoginViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 07/01/2021.
//

import Foundation
import RxSwift
import AuthenticationServices

final class LoginViewModel: BaseStateController {
    
    /// Authentication and user related businsess.
    private let userManager: UserManager
    
    /// RxSwift
    private let disposeBag = DisposeBag()
    
    var usernameIsValid = false
    var passwordIsValid = false
    
    init(_ userManager: UserManager) {
        self.userManager = userManager
    }
    
    func isLoginEnabled() -> Bool {
        return usernameIsValid && passwordIsValid
    }
}

// MARK: APIs
extension LoginViewModel {
    
    func login(email: String, password: String) {
        
        loadingState()
        
        userManager.login(email: email, password: password).subscribe(onSuccess: { [weak self] response in
            
            guard let self = self else {
                return
            }
            self.resultState()
            
        }, onError: { [weak self] error in
            
            self?.errorState(error)

        }).disposed(by: disposeBag)
    }
    
    // TODO: Needs to align with the BE about how to authenticate the user without a token.
    func login(with appleCredential: ASAuthorizationAppleIDCredential) {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        appleIDProvider.getCredentialState(forUserID: appleCredential.user) {  (credentialState, error) in
            
             switch credentialState {
                case .authorized:
                    /// The Apple ID credential is valid.
                    debugPrint("getCredentialState authorized")
                    break
                case .revoked:
                    /// The Apple ID credential is revoked.
                    debugPrint("getCredentialState revoked")
                    break
                case .notFound:
                    /// No credential was found, so show the sign-in UI.
                debugPrint("getCredentialState notFound")
                default:
                    break
             }
        }
    }
}
