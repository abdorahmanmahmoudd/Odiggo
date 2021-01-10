//
//  LoginViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 07/01/2021.
//

import Foundation
import RxSwift

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

}
