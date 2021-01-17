//
//  CategoriesViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 17/01/2021.
//

import Foundation
import RxSwift

final class CategoriesViewModel: BaseStateController {
    
    let apiClient: HomeRepository
    
    var topCategories: [Category] = []
    
    private let disposeBag = DisposeBag()
    
    init(_ apiClient: HomeRepository) {
        self.apiClient = apiClient
    }
}
