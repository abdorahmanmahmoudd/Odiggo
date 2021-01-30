//
//  ProductDetailsViewModel.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 28/01/2021.
//

import Foundation
import RxSwift

final class ProductDetailsViewModel: BaseStateController {
    
    private let apiClient: CategoriesRepository
    private let disposeBag = DisposeBag()
    private var productImages = [String?]()
    private var selectedProduct: Product
        
    init(_ apiClient: CategoriesRepository, product: Product) {
        self.apiClient = apiClient
        self.selectedProduct = product
        super.init()
    }
    
    func fetchProduct() {
        productImages = [selectedProduct.featuredImage, selectedProduct.featuredImage]
        resultState()
    }
}

// MARK: Datasource
extension ProductDetailsViewModel {
    
    func numberOfImages() -> Int {
        return productImages.count
    }
    
    func image(for index: IndexPath) -> String? {
        return productImages[safe: index.item] ?? ""
    }
}
