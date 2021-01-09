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
    private let authAPI: AuthenticationRepository
    
    /// RxSwift
    private let disposeBag = DisposeBag()
    
    init(_ authAPI: AuthenticationRepository) {
        self.authAPI = authAPI
    }
}

// MARK: APIs
extension SignupViewModel {
    
    func signup(username: String, email: String, password: String) {
        
        loadingState()
        
        authAPI.signup(username: username, email: email, password: password).subscribe(onSuccess: { [weak self] response in
            
            guard let self = self else {
                return
            }
            
            debugPrint("respose: \(response)")
            self.resultState()
            
        }, onError: { [weak self] error in
            
            self?.errorState(error)

        }).disposed(by: disposeBag)
    }

}
