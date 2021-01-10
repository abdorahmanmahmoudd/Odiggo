//
//  ForgetPasswordViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 10/01/2021.
//

import Foundation
import RxSwift

final class ForgetPasswordViewModel: BaseStateController {
    
    /// Authentication and user related businsess.
    private let api: AuthenticationRepository
    
    /// RxSwift
    private let disposeBag = DisposeBag()
    
    var emailIsValid = false
    private(set) var isPasswordResetDone = false
    
    init(_ api: AuthenticationRepository) {
        self.api = api
    }
    
    func isResetPasswordEnabled() -> Bool {
        return emailIsValid
    }
}

// MARK: APIs
extension ForgetPasswordViewModel {
    
    func resetPassword(email: String) {
        
        loadingState()
        
        api.resetPassword(email: email).subscribe(onSuccess: { [weak self] response in
            
            guard let self = self else {
                return
            }
            self.isPasswordResetDone = true
            self.resultState()
            
        }, onError: { [weak self] error in
            
            self?.errorState(error)

        }).disposed(by: disposeBag)
    }
}
