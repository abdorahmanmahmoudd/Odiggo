//
//  FeaturedCategoriesViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 14/01/2021.
//

import Foundation

final class HomeViewModel: BaseStateController {
    
    var apiClient: HomeRepository
    
    init(_ apiClient: HomeRepository) {
        self.apiClient = apiClient
    }
}
