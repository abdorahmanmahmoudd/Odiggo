//
//  FavouriteButton.swift
//  odiggo
//
//  Created by Abdelrahman Ali on 26/01/2021.
//

import UIKit

final class FavouriteButton: UIButton {
    
    private let favouritesManager = FavouriteProductsManager.shared
    private(set) var favouriteProduct: FavouriteProduct?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
    }
    
    func bind(to productId: Int) {
        favouriteProduct = favouritesManager.product(of: productId)
        
        if favouriteProduct == nil {
            favouriteProduct = FavouriteProduct(productId: productId)
            _ = favouritesManager.upsertProduct(favouriteProduct)
        }
        
        toggleView(favouriteProduct?.isFavourite ?? false)
    }
    
    private func toggleView(_ isFavourite: Bool) {
        
        if isFavourite {
            setImage(UIImage(named: "favourited.icon"), for: .normal)
            
        } else {
            setImage(UIImage(named: "unfavourite.icon"), for: .normal)
        }
    }
    
    func reset() {
        favouriteProduct = nil
        toggleView(false)
    }
    
    @objc
    private func buttonTapped() {
        
        favouriteProduct?.isFavourite.toggle()
        
        if favouritesManager.upsertProduct(favouriteProduct) {
            toggleView(favouriteProduct?.isFavourite ?? false)
        }
    }
}
