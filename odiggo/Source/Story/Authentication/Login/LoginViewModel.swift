//
//  LoginViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 07/01/2021.
//

import Foundation
import RxSwift

final class LoginViewModel: BaseStateController {
    
    /// Network requests
    private let authAPI: AuthenticationRepository
    
    /// RxSwift
    private let disposeBag = DisposeBag()
    
    init(_ authAPI: AuthenticationRepository) {
        self.authAPI = authAPI
    }
}

// MARK: APIs
extension LoginViewModel {
    
    func login(username: String, password: String) {
        
        loadingState()
        
        authAPI.login(username: username, password: password).subscribe(onSuccess: { [weak self] response in
            
            guard let self = self else {
                return
            }
            self.resultState()
            
        }, onError: { [weak self] error in
            
            self?.errorState(error)

        }).disposed(by: disposeBag)
    }

}
