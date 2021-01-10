//
//  SignupViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 08/01/2021.
//

import Foundation
import RxSwift

final class SignupViewModel: BaseStateController {
    
    /// Network requests
    private let userManager: UserManager
    
    /// RxSwift
    private let disposeBag = DisposeBag()
    
    var usernameIsValid = false
    var passwordIsValid = false
    var emailIsValid = false
    var passwordConfirmationIsValid = false
    
    init(_ userManager: UserManager) {
        self.userManager = userManager
    }
    
    func isSignupEnabled() -> Bool {
        return usernameIsValid && passwordIsValid && emailIsValid && passwordConfirmationIsValid
    }
}

// MARK: APIs
extension SignupViewModel {
    
    func signup(username: String, email: String, password: String) {
        
        loadingState()
        
        userManager.signup(username: username, email: email, password: password).subscribe(onSuccess: { [weak self] response in
            
            guard let self = self else {
                return
            }
            
            self.resultState()
            
        }, onError: { [weak self] error in
            
            self?.errorState(error)

        }).disposed(by: disposeBag)
    }

}
