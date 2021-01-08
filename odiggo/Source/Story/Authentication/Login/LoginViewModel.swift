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
